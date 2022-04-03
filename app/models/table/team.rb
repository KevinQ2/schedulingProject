class Team < ApplicationRecord
  belongs_to :project
  has_many :potential_allocations, dependent: :destroy

  validates :name, presence: true
  validates_uniqueness_of :name, :scope => :project_id
  validates :population, numericality: {greater_than: 0}
end
