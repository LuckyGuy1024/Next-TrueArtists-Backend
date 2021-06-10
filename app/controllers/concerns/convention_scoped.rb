# frozen_string_literal: true

module ConventionScoped
  extend ActiveSupport::Concern

  included do
    skip_before_action :authenticate_request!, only: %i[index show]
    before_action :find_convention, except: %i[index]
  end

  private

  def search
    @search ||= ConventionSearch.new(
      query: params[:query],
      options: search_options
    )
  end

  def find_convention
    @convention = Convention.friendly.find(params[:id])
  end

  def search_options
    {
      page: params[:page] || 1,
      per_page: params[:per_page] || BaseSearch::PER_PAGE,
      status: params[:status],
      near: params[:city] || params[:near],
      time_constraint: Date.today,
      within: params[:within]
    }.delete_if { |_k, v| v.nil? }
  end
end
