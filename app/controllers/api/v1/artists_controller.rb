# frozen_string_literal: true

module Api::V1
  class ArtistsController < ApplicationController
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_artist, except: %i[index create
                                           accept_artist_invite
                                           verify_phone_number
                                           phone_verification_code]

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

    def studios
      render json: ActiveModel::Serializer::CollectionSerializer.new(@artist.studios,
                                                                     serializer: StudioSerializer),
             status: :ok
    end

    def create
      artist = current_user.build_artist(artist_params)

      if artist.save
        render json: ArtistSerializer.new(artist).to_json, status: :created
      else
        render_api_error(status: 422, errors: artist.errors)
      end
    end

    def update
      authorize @artist
      artist = BaseForm.new(@artist, artist_params).update
      if artist
        render json: ArtistSerializer.new(@artist).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @artist.errors)
      end
    end

    def submit_for_review
      authorize @artist

      @artist.pending_review

      if @artist.save
        @artist.notify_admins

        head(:ok)
      else
        render_api_error(status: 422, errors: @artist.errors)
      end
    rescue AASM::InvalidTransition => e
      render_api_error(status: 422, errors: e.message)
    end

    def verify_phone_number
      authorize @artist, :update?
      if @artist.verify_phone_number(phone_verification_params[:code])
        head(:ok)
      else
        render_api_error(status: 422, errors: ['Enter a valid verification code'])
      end
    end

    def phone_verification_code
      authorize @artist, :update?
      if @artist.send_phone_verification_code
        head(:ok)
      else
        render_api_error(status: 422, errors: ['Enter a valid phone number'])
      end
    end

    def remove_image
      authorize @artist
      attachment = ActiveStorage::Attachment.find(params[:image_id]).purge
      if attachment.blank?
        head(:ok)
      else
        render_api_error(status: 422, errors: 'We could not delete resource')
      end
    end

    def studio_invites
      authorize @artist

      invites = StudioInvite.where(artist_id: @artist.id)

      render json: ActiveModel::Serializer::CollectionSerializer.new(invites,
                                                                     serializer: StudioInviteSerializer), status: :ok
    end

    private

    def find_artist
      @artist = Artist.friendly.find(params[:id])
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
        :name,
        :bio,
        :years_of_experience,
        :website,
        :facebook_url,
        :twitter_url,
        :instagram_url,
        :phone_number,
        :minimum_spend,
        :price_per_hour,
        :currency_code,
        :street_address,
        :cpr_certified,
        :street_address_2,
        :city,
        :state,
        :zip_code,
        :country,
        :street_address,
        :seeking_guest_spot,
        :guest_artist,
        :avatar,
        :hero_banner,
        specialty: []
      ).tap do |whitelisted|
        whitelisted[:style_ids] = params[:styles]
      end
    end
  end
end
