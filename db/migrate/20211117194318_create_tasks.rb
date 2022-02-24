class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.belongs_to :project
      t.string :title
      t.string :description
      t.integer :instances
      t.timestamps
    end
  end
end
