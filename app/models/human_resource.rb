class HumanResource < ApplicationRecord
  belongs_to :project
  has_many :task_resources, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :instances, presence: true
end
