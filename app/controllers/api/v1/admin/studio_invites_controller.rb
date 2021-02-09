# frozen_string_literal: true

module Api::V1::Admin
  class StudioInvitesController < BaseController
    before_action :find_studio, except: %i[accept_studio_invite]
    before_action :find_studio_invite, only: %i[accept_studio_invite]

    def create
      studio_invite = @studio.studio_invites.new(artist_invite_params)

      if studio_invite.invite_artist_to_studio
        head(:ok)
      else
        render_api_error(status: 422, errors: studio_invite.errors)
      end
    end

    private


    def find_studio
      @studio = current_user.studio
      head(:not_found) unless @studio
    end

    def artist_invite_params
      params.permit(
        :phone_number,
        :email
      )
    end
  end
end
