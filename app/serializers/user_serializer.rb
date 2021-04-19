class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :full_name, :role, :status, :slug
  has_one :artist
  has_one :studio
end
