SitemapGenerator::Sitemap.default_host = 'https://trueartists.com'
SitemapGenerator::Sitemap.sitemaps_path = 'shared/'

SitemapGenerator::Sitemap.create do
  add root_path, changefreq: 'daily', priority: 0.9
  add articles_path
  add artists_path
  add studios_path
  add styles_tattoos_path
  add placements_tattoos_path

  Artist.where(status: 'approved').find_each do |artist|
    add artist_path(artist.slug), lastmod: artist.updated_at, changefreq: 'weekly', priority: 0.5
  end

  Studio.where(status: 'approved').find_each do |studio|
    add studio_path(studio.slug), lastmod: studio.updated_at, changefreq: 'weekly', priority: 0.5
  end

  Style.find_each do |style|
    add style_tattoos_path(style.slug), lastmod: style.updated_at, changefreq: 'weekly', priority: 0.5
  end

  Placement.find_each do |placement|
    add placement_tattoos_path(placement.slug), lastmod: placement.updated_at, changefreq: 'weekly', priority: 0.5
  end

  Article.where(status: 'published').find_each do |studio|
    add article_path(article.slug), lastmod: article.updated_at, changefreq: 'weekly', priority: 0.5
  end

  LandingPage.where(status: 'published').find_each do |landing_page|
    add landing_page.page_key, lastmod: landing_page.updated_at, changefreq: 'weekly', priority: 0.5
  end

  add '/contact-us', changefreq: 'weekly', priority: 0.5
  add '/about-us', changefreq: 'weekly', priority: 0.5
  add '/terms', changefreq: 'weekly', priority: 0.5
  add '/privacy', changefreq: 'weekly', priority: 0.5
end

SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks
