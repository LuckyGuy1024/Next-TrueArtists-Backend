# frozen_string_literal: true

module Api::V1::Admin
  class GuestArtistApplicationsController < BaseController
    def index
      @applications = GuestArtistApplication.page(params[:page] || 1)

      render json: ActiveModel::Serializer::CollectionSerializer.new(@applications,
                                                                     serializer: GuestArtistApplicationSerializer),
             status: :ok
    end

    private

    def guest_artist_application_params
      params.permit(
        :studio_id,
        :phone_number,
        :message,
        :duration,
        :expected_start_date
      )
    end
  end
end
