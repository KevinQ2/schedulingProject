class TaskPrecedence < ApplicationRecord
  belongs_to :task, :class_name => "Task"
  belongs_to :required_task, :class_name => "Task"

  validate :same_project, :same_task
  validate :task_id
  validates_uniqueness_of :required_task_id, :scope => :task_id

  def same_task
    if !self.task_id.blank? and !self.required_task_id.blank?
      if self.task_id == self.required_task_id
        errors.add(:task_id, "tasks can't be identical")
      end
    end
  end

  def same_project
    task = Task.find_by_id(self.task_id)
    required_task = Task.find_by_id(self.required_task_id)

    if !task.nil? and !required_task.nil?
      if task.project != required_task.project
        errors.add(:task_id, "tasks can't be in different projects")
      end
    end
  end
end
