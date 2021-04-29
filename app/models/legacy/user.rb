module Legacy
  class User < Base
    def self.migrate
      connected_to(role: :reading) do
        find_each do |user|
          ActiveRecord::Base.connected_to(role: :writing) do
           new_user = ::User.find_or_initialize_by(email: user.email)
           binding.pry
           new_user.full_name = "#{user.first_name} #{user.last_name}"
           new_user.password_digest = user.encrypted_password
           new_user.created_at = user.created_at
           new_user.updated_at = user.updated_at
           new_user.save(validate: false)
          end
        end
      end
    end
  end
end
