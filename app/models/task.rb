class Task < ApplicationRecord
  belongs_to :project
  has_many :schedule_tasks, dependent: :destroy
  has_many :task_precedences, dependent: :destroy
  has_many :task_resources, dependent: :destroy

  validates :title, presence: true
  validates :instances, presence: true
end
