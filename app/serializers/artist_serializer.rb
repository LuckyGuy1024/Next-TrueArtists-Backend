class ArtistSerializer < ActiveModel::Serializer
  has_many :studios
  has_many :tattoos
  attributes :id,
             :user_id,
             :slug,
             :licensed,
             :years_of_experience,
             :styles,
             :website,
             :facebook_url,
             :twitter_url,
             :instagram_url,
             :phone_number,
             :minimum_spend,
             :price_per_hour,
             :currency_code,
             :street_address,
             :city,
             :state,
             :zip_code,
             :country,
             :seeking_guest_spot,
             :guest_artist
end
