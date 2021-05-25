class Api::V1::ClientsController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create]
  before_action :find_parent_object, except: :create
  before_action :find_client, only: %i[show update destroy]

  def index
    clients = if params[:query]
                @parent_object.clients.search(params[:query])
              else
                @parent_object.clients
              end

    @clients = paginate(clients)
    render json: ActiveModel::Serializer::CollectionSerializer.new(@clients,
                                                                   serializer: ClientSerializer),
           status: :ok
  end

  def show
    render json: ClientSerializer.new(@client).to_json, status: :ok
  end

  def create
    parent_object = Artist.find_by(id: params[:artist_id]) ||
                    Studio.find_by(id: params[:studio_id])

    client = parent_object.clients.new(client_params)

    if client.save
      render json: ClientSerializer.new(client).to_json, status: :created
    else
      render_api_error(status: 422, errors: client.errors)
    end
  end

  def update
    if @client.update(client_params)
      render json: ClientSerializer.new(@client).to_json, status: :ok
    else
      render_api_error(status: 422, errors: @client.errors)
    end
  end

  def destroy
    if @client.destroy
      head(:ok)
    else
      render_api_error(status: 422, errors: @client.errors)
    end
  end

  private

  def find_parent_object
    @parent_object = current_user.artist || current_user.studio
    head(:not_found) unless @parent_object
  end

  def find_client
    @client = @parent_object.clients.find(params[:id])
  end

  def client_params
    params.permit(
      :name,
      :email,
      :artist_id,
      :studio_id,
      :phone_number,
      :category,
      :date_of_birth,
      :email_notifications,
      :phone_notifications,
      :marketing_emails,
      :inactive,
      :zip_code,
      :referral_source,
      :comments
    )
  end
end
