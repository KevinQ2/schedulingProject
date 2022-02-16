class ScheduleTask < ApplicationRecord
  belongs_to :task
  belongs_to :human_resource

  validates :start_date, presence: true
  validates :end_date, presence: true
end
