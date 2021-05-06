# frozen_string_literal: true

module Frontend
  class GuestArtistApplicationsController < FrontendController
    before_action :find_application, only: %i[update destroy]
    before_action :find_artist, only: %i[create]
    def create
      application = @artist.guest_artist_applications.new(guest_artist_application_params)

      if application.save
        render json: GuestArtistApplicationSerializer.new(application).to_json, status: :created
      else
        render_api_error(status: 422, errors: application.errors)
      end
    end

    def update
      if @application.update(guest_artist_application_params)
        head(:ok)
      else
        render_api_error(status: 422, errors: @application.errors)
      end
    end

    def destroy
      if @application.destroy
        head(:ok)
      else
        render_api_error(status: 422, errors: @application.errors)
      end
    end

    def respond
      application = current_user.studio.guest_artist_applications.find(params[:id])

      application_response = application.build_guest_artist_application_response(
        application_response_params.merge(user_id: current_user.id)
      )

      if application_response.save
        render json: GuestArtistApplicationResponseSerializer.new(application_response).to_json, status: :created
      else
        render_api_error(status: 422, errors: application_response.errors)
      end
    end

    private

    def find_application
      @application = GuestArtistApplication.find(params[:id])
    end

    def find_artist
      artist = current_user.artist

      if artist
        @artist = artist
      else
        render_api_error(status: 404, errors: 'Resource not found')
      end
    end

    def guest_artist_application_params
      params.permit(
        :studio_id,
        :phone_number,
        :message,
        :duration,
        :expected_start_date
      )
    end

    def application_response_params
      params.permit(
        :message,
        :_destroy
      )
    end
  end
end
