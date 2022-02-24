class ScheduleTask < ApplicationRecord
  belongs_to :project
  belongs_to :task_resource

  validates :start_date, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
end
