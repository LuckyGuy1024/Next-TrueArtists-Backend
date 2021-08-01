class BookingSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  belongs_to :sender
  belongs_to :receiver

  attributes :id,
             :description,
             :placement,
             :consult_artist,
             :custom_size,
             :urgency,
             :size_units,
             :first_tattoo,
             :colored,
             :images

  def urgency
    object.urgency.strftime("%d-%m-%Y")
  end

  def images
    return unless object.images.attached?

    object.images.each do |image|
      {
        id: image.id,
        image_url: ENV['HOST'] + rails_blob_path(image, only_path: true),
        name: image.filename,
        dimensions: ActiveStorage::Analyzer::ImageAnalyzer.new(image).metadata,
        status: image.status
      }
    end
  end
end
