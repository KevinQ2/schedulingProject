class CreateOrganizationUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_users, primary_key: [:organization_id, :user_id] do |t|
      t.belongs_to :organization
      t.belongs_to :user
    end
  end
end
