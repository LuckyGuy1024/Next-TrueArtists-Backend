# frozen_string_literal: true

module Api::V1::Admin
  class LandingPagesController < ApplicationController
    before_action :find_landing_page, except: %i[create index]

    def index
      @results = LandingPageSearch.new(
        query: params[:query],
        options: search_options
      ).filter

      render json: @results, status: :ok
    end

    def show
      render json: LandingPageSerializer.new(@landing_page).to_json, status: :ok
    end

    def create
      landing_page = LandingPage.new(landing_page_params)

      if landing_page.save
        render json: LandingPageSerializer.new(landing_page).to_json, status: :created
      else
        render_api_error(status: 422, errors: landing_page.errors)
      end
    end

    def update
      landing_page = BaseForm.new(@landing_page, landing_page_params).update

      if landing_page
        render json: LandingPageSerializer.new(@landing_page).to_json, status: :ok
      else
        render_api_error(status: 422, errors: @landing_page.errors)
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

    def find_landing_page
      @landing_page = LandingPage.find(params[:id])
    end

    def search_options
      {
        page: params[:page] || 1,
        per_page: params[:per_page] || BaseSearch::PER_PAGE,
        status: params[:status],
      }.delete_if { |_k, v| v.nil? }
    end

    def landing_page_params
      params.permit(
        :page_key,
        :page_url,
        :avatar,
        :page_title,
        :meta_description,
        :title,
        :content
      ).tap do |whitelisted|
        whitelisted[:last_updated_by] = current_user.id
      end
    end
  end
end
