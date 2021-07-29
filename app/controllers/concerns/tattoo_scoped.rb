# frozen_string_literal: true

module TattooScoped
  extend ActiveSupport::Concern

  included do
    before_action :find_tattoo, except: %i[index facet]
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
      current_user_location: current_user_location
    }.delete_if { |_k, v| v.nil? }
  end

  def find_tattoo
    @tattoo = Tattoo.fetch(params[:id])
  end
end
