# frozen_string_literal: true

module StudioScoped
  extend ActiveSupport::Concern

  included do
    before_action :find_studio, except: %i[index city]
  end

  private

  def search
    @search = StudioSearch.new(
      query: params[:query],
      options: search_options
    )
  end

  def search_options
    {
      page: params[:page] || 1,
      per_page: params[:per_page] || BaseSearch::PER_PAGE,
      status: params[:status] || 'approved',
      current_user_location: current_user_location,
      near: params[:near],
      within: params[:within]
    }.delete_if { |_k, v| v.nil? }
  end

  def find_studio
    @studio = Studio.fetch_by_slug(params[:id])
    head(:not_found) unless @studio
  end
end
