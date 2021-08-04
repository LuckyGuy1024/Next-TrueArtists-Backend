class AdminUserSerializer < ActiveModel::Serializer
  attributes :id, :email, :full_name, :role, :status
 
end
