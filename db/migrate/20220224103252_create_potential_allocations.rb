class CreatePotentialAllocations < ActiveRecord::Migration[6.0]
  def change
    create_table :potential_allocations do |t|
      t.belongs_to :project
      t.belongs_to :task
      t.belongs_to :team
      t.integer :duration
      t.integer :capacity
      t.timestamps
    end
  end
end
