# frozen_string_literal: true

module Api::V1::Admin
  class StudiosController < BaseController
    before_action :find_studio, except: %i[index reject_image]

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
      studio = BaseForm.new(@studio, studio_params).update

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

    def approve
      if @studio.approve!
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def reject
      if @studio.reject!
        head(:ok)
      else
        render_api_error(status: 422, errors: @studio.errors)
      end
    end

    def destroy
      if @studio.destroy
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

    def reject_image
      attachment = ActiveStorageAttachment.find(params[:image_id])

      if attachment.update(status: 'rejected')
        head(:ok)
      else
        render_api_error(status: 422, errors: 'Resource could not be rejected')
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
        :email,
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
        :hero_banner,
        :monday,       
        :tuesday,      
        :wednesday,    
        :thursday,     
        :friday,       
        :saturday,     
        :sunday,       
        :monday_start,
        :tuesday_start,
        :wednesday_start,
        :thursday_start,
        :friday_start,
        :saturday_start,
        :sunday_start,
        :monday_end,
        :tuesday_end,
        :wednesday_end,
        :thursday_end,
        :friday_end,
        :saturday_end,
        :sunday_end
      )
    end
  end
end
