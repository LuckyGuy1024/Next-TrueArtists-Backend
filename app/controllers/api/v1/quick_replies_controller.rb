class Api::V1::QuickRepliesController < ApplicationController
  skip_before_action :authenticate_request!, only: %i[create]
  before_action :find_parent_object, except: :create
  before_action :find_quick_reply, only: %i[show update destroy]

  def index
    quick_replies = if params[:query]
                @parent_object.quick_replies.search(params[:query])
              else
                @parent_object.quick_replies
              end

    @quick_replies = paginate(quick_replies)
    render json: ActiveModel::Serializer::CollectionSerializer.new(@quick_replies,
                                                                   serializer: QuickReplySerializer),
           status: :ok
  end

  def show
    render json: QuickReplySerializer.new(@quick_replies).to_json, status: :ok
  end

  def create
    parent_object = Artist.find_by(id: params[:artist_id]) ||
                    Studio.find_by(id: params[:studio_id])

    client = parent_object.quick_replies.new(client_params)

    if client.save
      render json: QuickReplySerializer.new(client).to_json, status: :created
    else
      render_api_error(status: 422, errors: client.errors)
    end
  end

  def update
    if @quick_replies.update(client_params)
      render json: QuickReplySerializer.new(@quick_replies).to_json, status: :ok
    else
      render_api_error(status: 422, errors: @quick_replies.errors)
    end
  end

  def destroy
    if @quick_replies.destroy
      head(:ok)
    else
      render_api_error(status: 422, errors: @quick_replies.errors)
    end
  end

  private

  def find_parent_object
    @parent_object = current_user.artist || current_user.studio
    head(:not_found) unless @parent_object
  end

  def find_quick_reply
    @quick_replies = @parent_object.quick_replies.find(params[:id])
  end

  def client_params
    params.permit(
      :name,
      :category,
      :content,
      :active
    )
  end
end
