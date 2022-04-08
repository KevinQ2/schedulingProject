class OrganizationMember < ApplicationRecord
  belongs_to :organization
  belongs_to :user

  validates_uniqueness_of :user, :scope => :organization, :message => "already invited"

end
