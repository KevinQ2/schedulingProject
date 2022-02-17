class CreateScheduleTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :schedule_tasks do |t|
      t.belongs_to :project
      t.belongs_to :task
      t.belongs_to :human_resource
      t.integer :human_resource_instance_id
      t.integer :task_instance_id
      t.integer :start_date
      t.integer :end_date
      t.timestamps
    end
  end
end
