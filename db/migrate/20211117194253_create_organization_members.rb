class CreateOrganizationMembers < ActiveRecord::Migration[6.0]
  def change
    create_table :organization_members do |t|
      t.belongs_to :organization
      t.belongs_to :user
      t.boolean :is_host
      t.boolean :can_edit
      t.boolean :can_invite
    end
  end
end
