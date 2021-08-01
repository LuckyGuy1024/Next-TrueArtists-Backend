# frozen_string_literal: true

module ArtistScoped
  extend ActiveSupport::Concern

  included do
    before_action :find_artist, except: %i[index home city]
  end

  private

  def search
    @search = ArtistSearch.new(
      query: params[:query],
      options: search_options
    )
  end

  def search_options
    {
      page: params[:page] || 1,
      per_page: params[:per_page] || BaseSearch::PER_PAGE,
      status: params[:status] || 'approved',
      near: params[:near],
      styles: params[:styles],
      current_user_location: current_user_location,
      within: params[:within],
      studio_id: params[:studio_id],
      includes: { avatar_attachment: :blob }
    }.delete_if { |_k, v| v.nil? }
  end

  def find_artist
    @artist = Artist.fetch_by_slug(params[:id])
    head(:not_found) unless @artist
  end
end
