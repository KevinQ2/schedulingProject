class CreateScheduleTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :schedule_tasks, primary_key: [:task_id, :human_resource_id]  do |t|
      t.belongs_to :task
      t.belongs_to :human_resource
      t.integer :start_date
      t.integer :end_date
      t.timestamps
    end
  end
end
