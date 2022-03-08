class TaskResource < ApplicationRecord
  belongs_to :project
  belongs_to :task
  belongs_to :human_resource
  has_many :schedule_task, dependent: :destroy

  validates_uniqueness_of :task_id, :scope => :human_resource_id

  validates :duration, presence: true
  validates :capacity, presence: true

end
