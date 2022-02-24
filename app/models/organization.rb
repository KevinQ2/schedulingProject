class Organization < ApplicationRecord
  has_many :projects, dependent: :destroy
  has_many :organization_users, dependent: :destroy

  validates :name, presence: true

end
