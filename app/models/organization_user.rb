class OrganizationUser < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates_uniqueness_of :organization, :scope => :user
end
