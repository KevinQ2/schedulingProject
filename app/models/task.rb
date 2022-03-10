class Task < ApplicationRecord
  belongs_to :project
  has_many :task_precedences, dependent: :destroy
  has_many :task_resources, dependent: :destroy

  validates :title, presence: true
  validates :instances, presence: true
  
  validates_uniqueness_of :title, :scope => :project_id
end
