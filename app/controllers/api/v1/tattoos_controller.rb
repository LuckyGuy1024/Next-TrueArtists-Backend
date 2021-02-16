class Api::V1::TattoosController < ApplicationController
  before_action :find_parent_object, only: %i[create update destroy]
  before_action :find_tattoo, except: %i[create index batch_create]

  def index
    @tattoos = paginate(Tattoo.unscoped)
    render json: ActiveModel::Serializer::CollectionSerializer.new(@tattoos,
                                                                   serializer: TattooSerializer),
           status: :ok
  end

  def show
    render json: TattooSerializer.new(@tattoo).to_json, status: :ok
  end

  def batch_create
    errors = []
    processed = []

    params['tattoos'].each do |tattoo_params|
      permitted_params = tattoo_params.permit(permitted_attributes)
      tattoo = Tattoo.new(permitted_params)
      tattoo.image.attach(permitted_params[:image])

      if tattoo.save
        processed << {
          body: TattooSerializer.new(tattoo),
          status: :created
        }
      else
        errors << {
          body: tattoo.attributes.except('id', 'created_at', 'updated_at'),
          errors: tattoo.errors,
          status: 422
        }
      end
    end
    render json: { results: processed, errors: errors }, status: 200
  end

  def create
    tattoo = @parent_object.tattoos.new(tattoo_params)

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

  def find_parent_object
    @parent_object = @artist || @studio
    head(:not_found) unless @parent_object
  end

  def find_artist
    @artist = Artist.find(tattoo_params[:artist_id])
  end

  def find_studio
    @studio = Studio.find(params[:studio_id])
  end

  def find_tattoo
    @tattoo = Tattoo.find(params[:id])
  end

  def tattoo_params
    params.permit(*permitted_attributes)
  end

  def permitted_attributes
    %i[
      studio_id
      artist_id
      styles
      categories
      placement
      color
      size
      image
    ]
  end
end
