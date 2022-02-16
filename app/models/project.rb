class Project < ApplicationRecord
  belongs_to :organization
  has_many :tasks, dependent: :destroy
  has_many :human_resource, dependent: :destroy
  has_many :schedule_task, dependent: :destroy

  validates :name, presence: true
end
