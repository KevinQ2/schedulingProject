class Task < ApplicationRecord
  belongs_to :project
  has_many :schedule_tasks, dependent: :destroy
  has_many :task_precedences, dependent: :destroy
  has_many :human_resource, dependent: :destroy
  has_many :schedule_task, dependent: :destroy

  validates :title, presence: true
  validates :instances, presence: true
end
