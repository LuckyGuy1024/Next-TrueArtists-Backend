# frozen_string_literal: true

module Api::V1
  class ArtistsController < ApplicationController
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_artist, except: %i[index create accept_artist_invite verify_phone]

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
        head(:ok)
      else
        render_api_error(status: 422, errors: @artist.errors)
      end
    end

    def verify_phone
      artist = current_user.artist.verify_phone(phone_verification_params[:code])

      if artist
        head(:ok)
      else
        render_api_error(status: 422, errors: @artist.errors)
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

    private

    def find_artist
      @artist = Artist.fetch_by_slug(params[:id])
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
        :specialty,
        :city,
        :state,
        :zip_code,
        :country,
        :street_address,
        :seeking_guest_spot,
        :guest_artist,
        :avatar,
        :hero_banner
      ).tap do |whitelisted|
        whitelisted[:style_ids] = params[:styles]
      end
    end
  end
end
