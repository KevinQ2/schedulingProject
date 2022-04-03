module ProjectsHelper
  include TasksHelper
  include PotentialAllocationsHelper
  include SerialScheduleHelper
  include ParallelScheduleHelper
  include GeneticAlgorithmHelper

  def generate_schedule(project, scheme, rule, sampling, bias)
    start = Time.now  # stores running time

    if scheme == "Serial"
      return [get_serial_priority_schedule(project, rule, sampling, bias), Time.now - start]
    elsif scheme == "Parallel"
      return [get_parallel_schedule(project, rule, sampling, bias), Time.now - start]
    else
      flash.alert = "Invalid scheme"
    end
  end

  def generate_genetic_schedule(project)
    start = Time.now  # stores running time
    return [get_genetic_schedule(project), Time.now - start]
  end

  def generate_project(project, generate_project)
    project.save
    generate_tasks(project.id, generate_project.t_count)
    generate_teams(project.id, generate_project.t_count, generate_project.t_population_min..generate_project.t_population_max)
    generate_precedences(project.id, generate_project.p_chance)
    generate_allocations(project.id, generate_project.duration_min..generate_project.duration_max, generate_project.a_chance)
  end

  def generate_tasks(project, count)
    i = 1
    while i <= count
      Task.create(
        project_id: project,
        title: i
      )

      i += 1
    end
  end

  def generate_teams(project, count, range)
    i = 1
    while i <= count
      Team.create(
        project_id: project,
        name: i,
        population: rand(range)
      )

      i += 1
    end
  end

  def generate_precedences(project, chance)
    tasks = Task.where(:project_id => project).order('title::integer')  # only valid since we know title is an integer
    precedences = {}

    index = 0
    while index < tasks.count
      precedences[tasks[index]] = Set[]  # stores direct and indirect precedences for each task
      options = tasks[0, index] # slice has no risk of cycles by following order of array

      # traverse newer tasks first
      options.reverse.each do |option|
        # ignore existing direct/indirect precedence relations
        if !precedences[tasks[index]].include?(option)
          if rand(100) < chance
            TaskPrecedence.create(
              task_id: tasks[index].id,
              required_task_id: option.id
            )

            precedences[tasks[index]].add(option)
            precedences[tasks[index]].merge(precedences[option])
          end
        end
      end

      index += 1
    end
  end

  def generate_allocations(project, range, chance)
    tasks = Task.where(:project_id => project)
    teams = Team.where(:project_id => project)

    tasks.each do |task|
      allocated = false

      # each resource has a chance of being allocated
      teams.each do |team|
        if rand(100) < chance
          allocated = true

          PotentialAllocation.create(
            project_id: project,
            task_id: task.id,
            team_id: team.id,
            duration: rand(range),
            capacity: rand(1..team.population)
          )
        end
      end

      # ensure at least 1 allocation for each task
      if allocated == false
        team = teams[rand(0...teams.count)]

        PotentialAllocation.create(
          project_id: project,
          task_id: task.id,
          team_id: team.id,
          duration: rand(range),
          capacity: rand(1..team.population)
        )
      end
    end
  end
end
