# frozen_string_literal: true

module Api::V1
  class ArtistsController < ApplicationController
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

    def create
      artist = current_user.build_artist(artist_params)
      if artist.save
        render json: ArtistSerializer.new(artist).to_json, status: :created
      else
        render_api_error(status: 422, errors: artist.errors)
      end
    end

    def update
      artist = ArtistForm.new(@artist, artist_params).update
      if artist
        render json: ArtistSerializer.new(@artist).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @artist.errors)
      end
    end

    def verify_phone
      artist = current_user.artist.verify_phone(phone_verification_params[:code])

      if artist
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
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
        :slug,
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
        :city,
        :state,
        :zip_code,
        :country,
        :seeking_guest_spot,
        :guest_artist,
        :avatar,
        :hero_banner
      )
    end
  end
end
