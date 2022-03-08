class CreateOrganizationUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_users do |t|
      t.belongs_to :organization
      t.belongs_to :user
      t.boolean :can_edit
    end
  end
end
