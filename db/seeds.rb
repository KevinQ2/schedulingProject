# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

master_users = [
  ["user1", "pass1", "bob", "johnson", "bob.johnson@gmail.com", "01234123456"],
  ["user2", "pass2", "bill", "bobby", "bill.bobby@gmail.com", "01234123457"]
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
end

master_organization_member = [
  [1, 1, true, true, true]
]

master_organization_member.each do |temp|
  organization_member = OrganizationMember.create(
    organization_id: temp[0],
    user_id: temp[1],
    is_host: temp[2],
    can_edit: temp[3],
    can_invite: temp[4]
  )
end

master_projects = [
  [1, "Scheduling Project"]
]

master_projects.each do |temp|
  project = Project.create(
    organization_id: temp[0],
    name: temp[1]
  )
end

master_tasks = [
  [1, "1", 1],
  [1, "2", 1],
  [1, "3", 1],
  [1, "4", 1],
  [1, "5", 1],
  [1, "6", 1]
]

master_tasks.each do |temp|
  task = Task.create(
    project_id: temp[0],
    title: temp[1]
  )
end

master_task_precedences = [
  [3, 1],
  [5, 3],
  [4, 2],
  [6, 4]
]

master_task_precedences.each do |temp|
  precedence = TaskPrecedence.create(
    task_id: temp[0],
    required_task_id: temp[1]
  )
end

master_teams = [
  [1, "Team A", 4]
]

master_teams.each do |temp|
  team = Team.create(
    project_id: temp[0],
    name: temp[1],
    population: temp[2]
  )
end

master_potential_allocations = [
  [1, 1, 1, 3, 2],
  [1, 2, 1, 4, 3],
  [1, 3, 1, 2, 4],
  [1, 4, 1, 2, 4],
  [1, 5, 1, 1, 3],
  [1, 6, 1, 4, 2]
]

master_potential_allocations.each do |temp|
  potential_allocation = PotentialAllocation.create(
    project_id: temp[0],
    task_id: temp[1],
    team_id: temp[2],
    duration: temp[3],
    capacity: temp[4]
  )
end
