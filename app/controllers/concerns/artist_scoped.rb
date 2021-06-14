# frozen_string_literal: true

module ArtistScoped
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_artist, except: %i[index create accept_artist_invite verify_phone home]
  end

  private

  def search
    @search ||= ArtistSearch.new(
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
      styles: params[:styles],
      within: params[:within],
      studio_id: params[:studio_id],
    }.delete_if { |_k, v| v.nil? }
  end

  def find_artist
    @artist = Artist.fetch_by_slug(params[:id])
    head(:not_found) unless @artist
  end
end
