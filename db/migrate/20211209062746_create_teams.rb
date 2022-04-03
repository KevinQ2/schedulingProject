class CreateTeams < ActiveRecord::Migration[6.0]
  def change
    create_table :teams do |t|
      t.belongs_to :project
      t.string :name
      t.integer :population
      t.timestamps
    end
  end
end
