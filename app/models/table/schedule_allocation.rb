class ScheduleAllocation < ApplicationRecord
  belongs_to :project
  belongs_to :potential_allocation

  before_validation :fill_blank_dates

  validates_uniqueness_of :potential_allocation
  validates :start_date, presence: true, numericality: {greater_than_or_equal_to: 0}
  validates :end_date, presence: true, numericality: {greater_than: :start_date}
  validate :check_integrity

  def fill_blank_dates
    if !self.potential_allocation.nil?
      if self.start_date.blank? and self.end_date.is_a?(Numeric)
        self.start_date = self.end_date - self.potential_allocation.duration
      elsif self.end_date.blank? and self.start_date.is_a?(Numeric)
        self.end_date = self.start_date + self.potential_allocation.duration
      end
    end
  end

  def check_integrity
    if self.start_date.is_a?(Numeric) and self.end_date.is_a?(Numeric) and !self.potential_allocation.nil?
      if self.start_date != self.end_date - self.potential_allocation.duration
        errors.add(:task, "start and end date does not match duration of allocation")
      end
    end
  end
end
