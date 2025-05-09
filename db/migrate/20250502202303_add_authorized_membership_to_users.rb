class AddAuthorizedMembershipToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    add_column :users, :authorized_membership, :boolean
    add_column :users, :authorized_membership_updated_at, :datetime
  end
end
