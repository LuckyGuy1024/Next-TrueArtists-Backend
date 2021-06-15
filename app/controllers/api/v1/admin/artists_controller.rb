# frozen_string_literal: true

module Api::V1::Admin
  class ArtistsController < BaseController
    before_action :find_artist, except: %i[index reject_image]

    def index
      @results = ArtistSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def show
      render json: ArtistSerializer.new(@artist).to_json, status: :ok
    end

    def update
      artist = BaseForm.new(@artist, artist_params).update
      if artist
        render json: ArtistSerializer.new(@artist).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @artist.errors)
      end
    end

    def approve
      if @artist.approve!
        head(:ok)
      else
        render_api_error(status: 422, errors: @artist.errors)
      end
    rescue AASM::InvalidTransition => e
      render_api_error(status: 422, errors: e.message)
    end

    def reject
      if @artist.reject!
        head(:ok)
      else
        render_api_error(status: 422, errors: @artist.errors)
      end
    rescue AASM::InvalidTransition => e
      render_api_error(status: 422, errors: e.message)
    end

    def destroy
      if @artist.destroy
        head(:ok)
      else
        render_api_error(status: 422, errors: @artist.errors)
      end
    end

    def remove_image
      attachment = ActiveStorage::Attachment.find(params[:image_id]).purge
      if attachment.blank?
        head(:ok)
      else
        render_api_error(status: 422, errors: 'We could not delete resource')
      end
    end

    def reject_image
      attachment = ActiveStorageAttachment.find(params[:image_id])

      if attachment.update(status: 'rejected')
        head(:ok)
      else
        render_api_error(status: 422, errors: 'Resource could not be rejected')
      end
    end

    def studio_invites
      authorize @artist

      invites = StudioInvite.where(accepted: false, artist_id: @artist.id)

      render json: ActiveModel::Serializer::CollectionSerializer.new(invites,
                                                                     serializer: StudioInviteSerializer), status: :ok
    end

    private

    def find_artist
      @artist = Artist.find(params[:id])
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

    def artist_params
      params.permit(
        :licensed,
        :years_of_experience,
        :styles,
        :website,
        :facebook_url,
        :twitter_url,
        :instagram_url,
        :phone_number,
        :minimum_spend,
        :price_per_hour,
        :currency_code,
        :street_address,
        :street_address_2,
        :city,
        :state,
        :zip_code,
        :country,
        :street_address,
        :seeking_guest_spot,
        :guest_artist,
        :avatar,
        :hero_banner
      )
    end
  end
end
