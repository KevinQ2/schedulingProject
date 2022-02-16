class HumanResource < ApplicationRecord
  belongs_to :project
  has_many :schedule_task

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :instances, presence: true
end
