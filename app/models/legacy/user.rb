module Legacy
  class User < Base
    self.abstract_class = true
    self.table_name = "users"
    connects_to database: { reading: :legacy, writing: :primary }
    has_one :artist, dependent: :destroy, class_name: 'Legacy::Artist'
    has_many :studios, class_name: 'Legacy::Studios'

    def self.migrate
      ActiveRecord::Base.connected_to(role: :reading) do
        find_each do |user|
          ActiveRecord::Base.connected_to(role: :writing) do
            new_user = ::User.find_or_initialize_by(email: user.email)
            new_user.full_name = "#{user.first_name} #{user.last_name}"
            new_user.password_digest = user.encrypted_password
            new_user.created_at = user.created_at
            new_user.updated_at = user.updated_at
            new_user.save(validate: false, readonly: false)
          end
        end
      end
    end
  end
end
