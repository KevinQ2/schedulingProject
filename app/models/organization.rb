class Organization < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :organization_users, dependent: :destroy
  has_many :teams, dependent: :destroy

  validates :name, presence: true

end
