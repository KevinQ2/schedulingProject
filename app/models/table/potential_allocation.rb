class PotentialAllocation < ApplicationRecord
  belongs_to :project
  belongs_to :task
  belongs_to :team
  has_many :schedule_allocations, dependent: :destroy

  validate :same_project, :capacity_limit
  validates_uniqueness_of :task_id, :scope => :team_id
  validates :duration, numericality: {greater_than: 0}
  validates :capacity, numericality: {greater_than: 0}

  def same_project
    if !self.task.nil? and !self.team.nil?
      if self.task.project != self.team.project
        errors.add(:task, "task and team can't be in different projects")
      end
    end
  end

  def capacity_limit
    if !self.capacity.nil? and !self.team.nil?
      if self.capacity > self.team.population
        errors.add(:task, "capacity can't exceed team's population")
      end
    end
  end
end
