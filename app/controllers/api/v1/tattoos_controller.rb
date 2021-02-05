class Api::V1::TattoosController < ApplicationController
  before_action :find_tattoo, except: %i[create index]

  def index
    @tattoos = Tattoo.paginate(page: params[:page], per_page: 10)
    # @tattoos = paginate(Tattoo.unscoped.includes(:variant_mappings, :data_sources))
    render json: ActiveModel::Serializer::CollectionSerializer.new(@tattoos,
                                                                   serializer: TattooSerializer),
           status: :ok
  end

  def show
    render json: TattooSerializer.new(@tattoo).to_json, status: :ok
  end

  def create
    tattoo = Tattoo.new(tattoo_params)
    tattoo.user_id = @current_user&.id

    if tattoo.save
      render json: TattooSerializer.new(tattoo).to_json, status: :created
    else
      render_api_error(status: 422, errors: tattoo.errors)
    end
  end

  def update
    if @tattoo.update(tattoo_params)
      render json: TattooSerializer.new(@tattoo).to_json, status: :ok
    else
      render_api_error(status: 422, errors: @tattoo.errors)
    end
  end

  private

  def find_tattoo
    @tattoo = Tattoo.find(params[:id])
  end

  def tattoo_params
    params.permit(
      :studio_id,
      :artist_id,
      :styles,
      :category,
      :placement,
      :color,
      :size,
      attachments_attributes: []
    )
  end
end
