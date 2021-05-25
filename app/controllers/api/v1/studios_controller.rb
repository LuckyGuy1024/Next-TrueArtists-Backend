# frozen_string_literal: true

module Api::V1
  class StudiosController < ApplicationController
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_studio, except: %i[create index verify_phone]
    before_action :find_application, only: %i[application]

    def index
      @results = StudioSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def city
      Studio.near(params[:city], 500)
    end

    def show
      render json: StudioSerializer.new(@studio).to_json, status: :ok
    end

    def artists
      render json: ActiveModel::Serializer::CollectionSerializer.new(@studio.artists,
                                                                     serializer: ArtistSerializer),
             status: :ok
    end

    def create
      studio = Studio.create_studio(current_user, studio_params)

      if studio.save
        render json: StudioSerializer.new(studio).to_json, status: :created
      else
        render_api_error(status: 422, errors: studio.errors)
      end
    end

    def submit_for_review
      authorize @studio
      @studio.pending_review
      if @studio.save
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def update
      authorize @studio
      studio = BaseForm.new(@studio, studio_params).update

      if studio
        render json: StudioSerializer.new(@studio).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def invite_artist
      authorize @studio
      if @studio.invite_artist(artist_invite_params)
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def verify_phone
      studio = current_user.studio.verify_phone(phone_verification_params[:code])

      if studio
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def remove_image
      authorize @studio
      attachment = ActiveStorage::Attachment.find(params[:image_id]).purge
      if attachment.blank?
        head(:ok)
      else
        render_api_error(status: 422, errors: 'We could not delete resource')
      end
    end

    def guest_artist_applications
      @applications = current_user.studio.guest_artist_applications.page(params[:page] || 1)

      render json: ActiveModel::Serializer::CollectionSerializer.new(@applications,
                                                                     serializer: GuestArtistApplicationSerializer),
             status: :ok
    end

    def application
      render json: GuestArtistApplicationSerializer.new(@application).to_json, status: :ok
    end

    private

    def find_studio
      @studio = Studio.friendly.find(params[:id])
    end

    def find_application
      @application = current_user.studio.guest_artist_applications.find(params[:id])
    end

    def search_options
      {
        page: params[:page] || 1,
        per_page: params[:per_page] || BaseSearch::PER_PAGE,
        status: params[:status],
        near: params[:city] || params[:near],
        within: params[:within]
      }.delete_if { |_k, v| v.nil? }
    end

    def phone_verification_params
      params.permit(:code)
    end

    def studio_params
      params.permit(
        :name,
        :email,
        :phone_number,
        :bio,
        :avatar,
        :hero_banner,
        :street_address,
        :street_address_2,
        :city,
        :state,
        :zip_code,
        :country,
        :website_url,
        :facebook_url,
        :twitter_url,
        :instagram_url,
        :accepting_guest_artist,
        :accepted_payment_methods,
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
        :services,
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
        :hero_banner,
        working_hours: {}
      )
    end
  end
end
