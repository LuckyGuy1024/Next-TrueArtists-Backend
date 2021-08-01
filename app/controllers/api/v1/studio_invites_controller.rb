# frozen_string_literal: true

module Api::V1
  class StudioInvitesController < ApplicationController
    before_action :find_studio, only: %i[create]
    before_action :find_studio_invite, except: %i[create]
    before_action :find_artist, only: %i[accept_studio_invite]

    def create
      studio_invite = @studio.studio_invites.new(artist_invite_params)

      if studio_invite.invite_artist_to_studio
        head(:ok)
      else
        render_api_error(status: 422, errors: studio_invite.errors)
      end
    end

    def accept_studio_invite
      authorize @studio_invite if current_user

      if @studio_invite.accept_invite!(@artist.id)
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio_invite.errors)
      end
    end

    def reject_studio_invite
      authorize @studio_invite

      if @studio_invite.reject!
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio_invite.errors)
      end
    rescue AASM::InvalidTransition => e
      render_api_error(status: 422, errors: e.message)
    end

    def cancel_studio_invite
      authorize @studio_invite

      if @studio_invite.cancel_invite!
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio_invite.errors)
      end
    end

    private

    def find_artist
      @artist = if params[:token]
                  StudioInvite.find_by(invite_code: params[:token]).artist
                else
                  current_user.artist
                end
      head(:not_found) unless @artist
    end

    def find_studio
      @studio = Studio.find(params[:id])
    end

    def find_studio_invite
      @studio_invite = if params[:token]
                         StudioInvite.find_by(invite_code: params[:token])
                       else
                         StudioInvite.find(params[:id])
                       end
      head(:not_found) unless @studio_invite
    end

    def artist_invite_params
      params.permit(
        :phone_number,
        :email
      )
    end
  end
end
