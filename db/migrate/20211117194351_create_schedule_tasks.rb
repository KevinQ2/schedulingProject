class CreateScheduleTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :schedule_tasks do |t|
      t.belongs_to :project
      t.belongs_to :task_resource
      t.integer :start_date
      t.integer :end_date
      t.timestamps
    end
  end
end
