module EmailHelper
  def email_image_tag(image, **options)
    attachments[image] ||= File.read(Rails.root.join("app/assets/images/#{image}"))
    image_tag attachments[image].url, **options
  end

  def row_styles
    "margin: 0 0 36px 0;"
  end
end
