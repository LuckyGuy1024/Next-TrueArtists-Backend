# frozen_string_literal: true

module Api::V1::Admin
  class DashboardController < BaseController
    def index
      @users = { users: { total: User.all.size,
                          admin: User.where(role: 'admin').size,
                          artists: User.where(role: 'artist').size,
                          studios: User.where(role: 'studio_manager').size,
                          regular: User.where(role: 'regular').size,
                          active: User.where(status: 'active').size,
                          inactive: User.where(status: 'inactive').size,
                          suspended: User.where(status: 'suspended').size,
                          closed: User.where(status: 'closed').size
                        }
                 }
      
      @styles = { styles: { total: Style.all.size }}

      @artists = { artists: { total: Artist.all.size,
                              pending: Artist.where(status: 'pending').size,
                              approved: Artist.where(status: 'approved').size,
                              rejected: Artist.where(status: 'rejected').size
                            }
                  }

      @studios = { studios: { total: Studio.all.size,
                              pending: Studio.where(status: 'pending').size,
                              approved: Studio.where(status: 'approved').size,
                              rejected: Studio.where(status: 'rejected').size
                            }
                  }

      @articles = { articles: { total: Article.all.size,
                                drafts: Article.where(status: 'draft').size,
                                published: Article.where(status: 'published').size,
                                flagged: Article.where(status: 'flagged').size
                              }
                  }
      
      @landing_pages = { landing_pages: { total: LandingPage.all.size,
                                          drafts: LandingPage.where(status: 'draft').size,
                                          published: LandingPage.where(status: 'published').size,
                                          archived: LandingPage.where(status: 'archived').size,
                                          artists: LandingPage.where('page_key LIKE ?', '%/artists/%').size,
                                          studios: LandingPage.where('page_key LIKE ?', '%/studios/%').size
                                        }
      }

      @conventions = { conventions: { total: Convention.all.size,
                                      active: Convention.where('start_date >= ?', Time.now).size,
                                      inactive: Convention.where('end_date < ?', Time.now).size
                                    }
      }
      
      render json: [@users, @artists, @studios, @articles, @landing_pages, @conventions,  @styles], status: :ok
    end
  end
end
