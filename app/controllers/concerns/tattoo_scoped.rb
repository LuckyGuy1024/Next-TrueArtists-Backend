# frozen_string_literal: true

module TattooScoped
  extend ActiveSupport::Concern

  included do
    before_action :find_tattoo, except: %i[index facet styles placements]
  end

  private

  def search
    @search = TattooSearch.new(
      query: params[:query],
      options: search_options
    )
  end

  def search_options
    {
      page: params[:page] || 1,
      per_page: params[:per_page] || BaseSearch::PER_PAGE,
      status: params[:status],
      placement: params[:placement],
      styles: params[:styles],
      color: params[:color],
      near: params[:near],
      within: params[:within],
      studio_id: params[:studio_id],
      artist_id: params[:artist_id],
      includes: { image_attachment: :blob }
    }.delete_if { |_k, v| v.nil? }
  end

  def find_tattoo
    @tattoo = Tattoo.fetch_by_slug_and_status(params[:id], 'approved').first
    head(:not_found) unless @tattoo
  end
end
