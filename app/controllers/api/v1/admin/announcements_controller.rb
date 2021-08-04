module Api::V1::Admin
  class AnnouncementsController < BaseController
    before_action :find_announcement, except: %i[index create]

    def index
      @announcements = paginate(Announcement.order("created_at DESC"))
      render json: ActiveModel::Serializer::CollectionSerializer.new(@announcements,
                                                                     serializer: AnnouncementSerializer),
             status: :ok
    end

    def show
      render json: AnnouncementSerializer.new(@announcement).to_json, status: :ok
    end

    def create
      announcement = current_user.announcements.new(announcement_params)

      if announcement.save
        render json: AnnouncementSerializer.new(announcement).to_json, status: :created
      else
        render_api_error(status: 422, errors: announcement.errors)
      end
    end

    def update
      announcement = BaseForm.new(@announcement, announcement_params).update

      if announcement
        render json: AnnouncementSerializer.new(@announcement).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @announcement.errors)
      end
    end

    def destroy
      if @announcement.destroy
        head(:ok)
      else
        render_api_error(status: 422, errors: @announcement.errors)
      end
    end

    def publish
      if @announcement.publish!
        head(:ok)
      else
        render_api_error(status: 422, errors: @announcement.errors)
      end
    rescue AASM::InvalidTransition => e
      render_api_error(status: 422, errors: e.message)
    end

    private

    def find_announcement
      @announcement = Announcement.find(params[:id])
    end

    def announcement_params
      params.permit(
        :title,
        :content,
        :publish_on,
        :send_now,
        :image,
        :recipients,
        :custom_emails
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
