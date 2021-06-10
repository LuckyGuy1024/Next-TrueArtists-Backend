# frozen_string_literal: true

class AdminConventionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id,
             :name,
             :description,
             :link_to_official_site,
             :start_date,
             :end_date,
             :verified
end
