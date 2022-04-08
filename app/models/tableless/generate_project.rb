class GenerateProject < ApplicationModel
  attr_accessor :initial_task, :task_count, :max_prec, :t_count, :t_population_min, :t_population_max, :duration_min, :duration_max, :a_chance

  validates :initial_task, presence: true
  validates :task_count, presence: true
  validates :max_prec, presence: true
  validates :t_count, presence: true
  validates :t_population_min, presence: true
  validates :t_population_max, presence: true
  validates :duration_min, presence: true
  validates :duration_max, presence: true
  validates :a_chance, presence: true

  validate :convert_type
  validate :must_be_range

  def convert_type
    self.initial_task = initial_task.to_i
    self.task_count = task_count.to_i
    self.max_prec = max_prec.to_i
    self.t_count = t_count.to_i
    self.t_population_min = t_population_min.to_i
    self.t_population_max = t_population_max.to_i
    self.duration_min = duration_min.to_i
    self.duration_max = duration_max.to_i
    self.a_chance = a_chance.to_i
  end

  def must_be_range
    if t_population_min > t_population_max or duration_min > duration_max
      errors.add(:base, 'Maximum must be greater than the minimum')
    end
  end
end
