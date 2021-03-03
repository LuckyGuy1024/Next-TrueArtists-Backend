class Api::V1::TattoosController < ApplicationController
  before_action :find_parent_object, only: %i[create batch_create destroy]
  before_action :find_tattoo, except: %i[create index batch_create]

  def index
    @results = TattooSearch.new(
      query: params[:query],
      options: search_options
    ).filter

    render json: @results, status: :ok
  end

  def show
    render json: TattooSerializer.new(@tattoo).to_json, status: :ok
  end

  def batch_create
    errors = []
    processed = []

    params['tattoos'].each do |tattoo_object|
      permitted_params = tattoo_object.permit(permitted_attributes)
      tattoo = @parent_object.tattoos.new(permitted_params)

      if tattoo.save
        tattoo.image.attach(permitted_params[:image])

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
    tattoo_params = params.permit(permitted_attributes)
    if @tattoo.update(tattoo_params)
      @tattoo.image.attach(tattoo_params[:image]) if tattoo_params[:image]

      render json: TattooSerializer.new(@tattoo).to_json, status: :ok
    else
      render_api_error(status: 422, errors: @tattoo.errors)
    end
  end

  def flag
    @tattoo.flag
    if @tattoo.save
      head(:ok)
    else
      render_api_error(status: 422, errors: @tattoo.errors)
    end
  end

  private

  def find_parent_object
    @parent_object = current_user.artist || current_user.studio
    head(:not_found) unless @parent_object
  end

  def find_tattoo
    @tattoo = Tattoo.find(params[:id])
  end

  def permitted_attributes
    [:styles,
     :categories,
     :placement,
     :color,
     :size,
     :image,
     { tag_list: [] }]
  end

  def search_options
    {
      page: params[:page] || 1,
      per_page: params[:per_page] || BaseSearch::PER_PAGE,
      status: params[:status],
      near: params[:near],
      within: params[:within]
    }.delete_if { |_k, v| v.nil? }
  end
end
