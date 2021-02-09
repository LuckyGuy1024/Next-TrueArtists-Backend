class Api::V1::Admin::TattoosController < AdminController
  before_action :find_tattoo, except: %i[index batch_create]

  def index
    @tattoos = Tattoo.paginate(page: params[:page], per_page: 10)
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
