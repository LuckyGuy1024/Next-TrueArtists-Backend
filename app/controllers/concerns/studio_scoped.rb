# frozen_string_literal: true

module StudioScoped
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_studio, except: %i[index create accept_artist_invite verify_phone city]
  end

  private

  def search
    @search ||= StudioSearch.new(
      query: params[:query],
      options: search_options
    )
  end

  def search_options
    {
      page: params[:page] || 1,
      per_page: params[:per_page] || BaseSearch::PER_PAGE,
      status: params[:status] || 'approved' ,
      near: params[:near],
      within: params[:within],
      current_user_coordinates: current_user_coordinates
    }.delete_if { |_k, v| v.nil? }
  end

  def find_studio
    @studio = Studio.fetch_by_slug(params[:id])
    head(:not_found) unless @studio
  end
end
