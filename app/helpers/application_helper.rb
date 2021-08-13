module ApplicationHelper
  def full_url(url)
    return nil unless url.present?
    "https://#{url}" unless url[%r{\Ahttp://}] || url[%r{\Ahttps://}]
  end
end
