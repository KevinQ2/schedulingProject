class CreateHumanResources < ActiveRecord::Migration[6.0]
  def change
    create_table :human_resources do |t|
      t.belongs_to :project
      t.string :name
      t.integer :instances
      t.timestamps
    end
  end
end
