class CreateScheduleAllocations < ActiveRecord::Migration[6.0]
  def change
    create_table :schedule_allocations do |t|
      t.belongs_to :project
      t.belongs_to :potential_allocations
      t.integer :start
      t.integer :end
      t.timestamps
    end
  end
end
