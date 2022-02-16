# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

master_users = [
  ["user1", "pass1", "bob", "johnson", "bob.johnson@gmail.com", "01234123456"],
  ["user2", "pass2", "bob", "johnson", "bob.johnson@gmail.com", "01234123456"]
]

master_users.each do |temp|
  user = User.create(
    username: temp[0],
    first_name: temp[2],
    last_name: temp[3],
    email: temp[4],
    telephone: temp[5],
  )
  user.password = temp[1]
  user.save
end

master_organizations = [
  ["Schedule Corp"]
]

master_organizations.each do |temp|
  organization = Organization.create(
    name: temp[0]
  )
  organization.save
end

master_organization_user = [
  [1, 1]
]

master_organization_user.each do |temp|
  organization_user = OrganizationUser.create(
    organization_id: temp[0],
    user_id: temp[1]
  )
  organization_user.save
end

master_projects = [
  [1, "Scheduling Project"]
]

master_projects.each do |temp|
  project = Project.create(
    organization_id: temp[0],
    name: temp[1]
  )
  project.save
end
