class TaskResource < ApplicationRecord
  belongs_to :project
  belongs_to :task
  belongs_to :human_resource
  has_many :schedule_task, dependent: :destroy

  validates :duration, presence: true
  validates :capacity, presence: true

end
