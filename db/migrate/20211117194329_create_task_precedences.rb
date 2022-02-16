class CreateTaskPrecedences < ActiveRecord::Migration[6.0]
  def change
    create_table :task_precedences do |t|
      t.belongs_to :task, class_name: "Task"
      t.belongs_to :required_task, class_name: "Task"
      t.timestamps
    end
  end
end
