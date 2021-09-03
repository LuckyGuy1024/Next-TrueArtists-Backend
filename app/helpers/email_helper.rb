module EmailHelper
  def email_image_tag(image, **options)
    attachments[image] ||= File.read(Rails.root.join("app/assets/images/#{image}"))
    image_tag attachments[image].url, **options
  end

  def row_styles
    "margin: 0 0 15px 0; font-size: 14px"
  end

  def h2_styles
    "margin-top:0;margin-bottom:16px;font-size:22px;line-height:32px;font-weight:lighter;letter-spacing:-0.02em;"
  end
end
