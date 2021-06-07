# frozen_string_literal: true

module Api::V1::Admin
  class DashboardController < BaseController
    def index
      @users = { users: { total: User.count,
                          admin: User.where(role: 'admin').count,
                          artists: User.where(role: 'artist').count,
                          studios: User.where(role: 'studio_manager').count,
                          regular: User.where(role: 'regular').count,
                          active: User.where(status: 'active').count,
                          inactive: User.where(status: 'inactive').count,
                          suspended: User.where(status: 'suspended').count,
                          closed: User.where(status: 'closed').count } }

      @styles = { styles: { total: Style.count } }

      @artists = { artists: { total: Artist.count,
                              pending: Artist.where(status: 'pending').count,
                              approved: Artist.where(status: 'approved').count,
                              rejected: Artist.where(status: 'rejected').count } }

      @studios = { studios: { total: Studio.count,
                              pending: Studio.where(status: 'pending').count,
                              approved: Studio.where(status: 'approved').count,
                              rejected: Studio.where(status: 'rejected').count } }

      @articles = { articles: { total: Article.count,
                                drafts: Article.where(status: 'draft').count,
                                published: Article.where(status: 'published').count,
                                flagged: Article.where(status: 'flagged').count } }

      @landing_pages = { landing_pages: { total: LandingPage.count,
                                          drafts: LandingPage.where(status: 'draft').count,
                                          published: LandingPage.where(status: 'published').count,
                                          archived: LandingPage.where(status: 'archived').count } }

      @conventions = { conventions: { total: Convention.count,
                                      active: Convention.where('start_date >= ?', Time.now).count,
                                      inactive: Convention.where('end_date < ?', Time.now).count } }

      render json: [@users, @artists, @studios, @articles, @landing_pages, @conventions, @styles], status: :ok
    end
  end
end
