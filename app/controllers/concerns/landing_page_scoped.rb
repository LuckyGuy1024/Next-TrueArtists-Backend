# frozen_string_literal: true

module LandingPageScoped
  extend ActiveSupport::Concern

  private

  def search
    @search ||= LandingPageSearch.new(
      query: params[:query],
      options: search_options
    )
  end

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
end
