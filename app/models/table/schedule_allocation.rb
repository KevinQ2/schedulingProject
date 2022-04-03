class ScheduleAllocation < ApplicationRecord
  belongs_to :project
  belongs_to :potential_allocation

  validates_uniqueness_of :potential_allocation
  validates :start, presence: true
  validates :end, presence: true
end
