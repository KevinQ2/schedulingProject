class CreateProjects < ActiveRecord::Migration[6.0]
  def change
    create_table :projects do |t|
      t.belongs_to :organization
      t.string :name
      t.timestamps
    end
  end
end
