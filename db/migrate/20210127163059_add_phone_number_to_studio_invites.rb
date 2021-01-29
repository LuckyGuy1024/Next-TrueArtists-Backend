class AddPhoneNumberToStudioInvites < ActiveRecord::Migration[6.0]
  def change
    add_column :studio_invites, :phone_number, :string
  end
end
