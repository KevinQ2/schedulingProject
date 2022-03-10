class HumanResource < ApplicationRecord
  belongs_to :project
  has_many :task_resources, dependent: :destroy

  validates :name, presence: true
  validates :instances, presence: true

  validates_uniqueness_of :name, :scope => :project_id
end
