class Task < ApplicationRecord
  belongs_to :project
  has_many :task_precedences, dependent: :destroy
  has_many :potential_allocations, dependent: :destroy

  validates :title, presence: true
  validates_uniqueness_of :title, :scope => :project_id
end
