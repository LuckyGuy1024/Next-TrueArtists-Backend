module ApplicationHelper
  def validate_url(website_url)
    URI.parse(website_url).is_a?(URI::HTTP) or URI.parse(website_url).is_a?(URI::HTTPS)
  end
end
