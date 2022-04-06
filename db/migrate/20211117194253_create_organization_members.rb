class CreateOrganizationMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_members do |t|
      t.belongs_to :organization
      t.belongs_to :user
      t.boolean :is_host, default: false
      t.boolean :can_edit, default: false
      t.boolean :can_invite, default: false
    end
  end
end
