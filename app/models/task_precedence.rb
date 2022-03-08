class TaskPrecedence < ApplicationRecord
  belongs_to :task

  validates_uniqueness_of :required_task_id, :scope => :task_id
end
