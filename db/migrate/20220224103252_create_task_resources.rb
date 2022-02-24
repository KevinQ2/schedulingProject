class CreateTaskResources < ActiveRecord::Migration[6.0]
  def change
    create_table :task_resources do |t|
      t.belongs_to :project
      t.belongs_to :task
      t.belongs_to :human_resource
      t.integer :duration
      t.integer :capacity
      t.timestamps
    end
  end
end
