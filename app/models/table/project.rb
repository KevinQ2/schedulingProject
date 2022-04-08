class Project < ApplicationRecord
  belongs_to :organization
  has_many :tasks, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :schedule_allocations, dependent: :destroy

  validates :name, presence: true
  validates_uniqueness_of :name, :scope => :organization_id
end
