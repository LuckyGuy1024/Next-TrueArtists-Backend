# frozen_string_literal: true

class ConventionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  belongs_to :user

  attributes :id,
             :name,
             :description,
             :link_to_official_site,
             :facebook_link,
             :start_date,
             :end_date,
             :address,
             :city,
             :state,
             :country,
             :status, 
             :slug,
             :image

  def image
    if object.image.attached?
      {
        id: object.image.id,
        image_url: ENV['HOST'] + rails_blob_path(object.image, only_path: true),
        name: object.image.filename,
        dimensions: ActiveStorage::Analyzer::ImageAnalyzer.new(object.image).metadata,
        status: object.image.status
      }
    end
  end
end
