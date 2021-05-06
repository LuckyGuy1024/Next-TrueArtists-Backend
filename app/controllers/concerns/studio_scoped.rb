# frozen_string_literal: true

module StudioScoped
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_studio, except: %i[index create accept_artist_invite verify_phone]
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
      status: params[:status],
      near: params[:near],
      within: params[:within]
    }.delete_if { |_k, v| v.nil? }
  end

  def find_studio
    @studio = Studio.fetch_by_slug(params[:id])
  end
end
