class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :role, :status
end
