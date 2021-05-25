class ClientSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :email,
             :phone_number,
             :category,
             :date_of_birth,
             :email_notifications,
             :phone_notifications,
             :marketing_emails,
             :inactive,
             :zip_code,
             :referral_source,
             :comments
end
