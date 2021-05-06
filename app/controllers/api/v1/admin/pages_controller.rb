module Api::V1::Admin
  class PagesController < BaseController
    before_action :find_page, except: %i[index create]

    def index
      @pages = paginate(Page.unscoped)
      render json: ActiveModel::Serializer::CollectionSerializer.new(@pages,
                                                                     serializer: ClientSerializer),
             status: :ok
    end

    def show
      render json: PageSerializer.new(@page).to_json, status: :ok
    end

    def create
      page = Page.new(page_params)

      if page.save
        render json: PageSerializer.new(page).to_json, status: :created
      else
        render_api_error(status: 422, errors: page.errors)
      end
    end

    def update
      page = BaseForm.new(@page, page_params).update

      if page
        render json: PageSerializer.new(@page).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @page.errors)
      end
    end

    def destroy
      if @page.destroy
        head(:ok)
      else
        render_api_error(status: 422, errors: @page.errors)
      end
    end


    private

    def find_page
      @page = Page.friendly.find(params[:id])
    end

    def page_params
      params.permit(
        :title,
        :content,
        :slug,
        :active,
        :parent_id
      )
    end

    def search_options
      {
        page: params[:page] || 1,
        per_page: params[:per_page] || BaseSearch::PER_PAGE,
        status: params[:status]
      }.delete_if { |_k, v| v.nil? }
    end
  end
end
