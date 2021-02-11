# frozen_string_literal: true

module Api::V1::Admin
  class StudiosController < BaseController
    before_action :find_studio, except: %i[create index]

    def index
      @results = StudioSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def show
      render json: StudioSerializer.new(@studio).to_json, status: :ok
    end

    def update
      studio = StudioForm.new(@studio, studio_params).update

      if studio
        render json: StudioSerializer.new(@studio).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def invite_artist
      if @studio.invite_artist(artist_invite_params)
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

    def find_studio
      @studio = Studio.find(params[:id])
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

    def studio_params
      params.permit(
        :user_id,
        :email,
        :lat,
        :lon,
        :accepting_guest_artist,
        :piercings,
        :cosmetic_tattoos,
        :appointment_only,
        :vegan_ink,
        :wifi,
        :privacy_dividers,
        :wheelchair_access,
        :parking,
        :lgbt_friendly,
        :languages,
        :name,
        :bio,
        :slug,
        :services,
        :specialty,
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
        :guest_studio,
        :avatar,
        :hero_banner
      )
    end
  end
end
