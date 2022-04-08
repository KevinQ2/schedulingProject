module ScheduleHelper
  using PriorityRuleHelper
  using ProjectsHelper

  def initialise_environment(project)
    # gather the relevant tasks and teams
    tasks = []
    resources = {}

    Task.where(:project_id => project.id).each do |task|
      tasks.push(task.id)
    end

    Team.where(:project_id => project.id).each do |team|
      resources[team.id] = team.population
    end

    return tasks, resources
  end

  def check_precedence_feasible(completed, task)
    precedences = TaskPrecedence.where(:task_id => task)

    precedences.each do |precedence|
      if completed[precedence.required_task_id] == nil
        return false
      end
    end

    return true
  end

  def check_resource_feasible(task, resources)
    records = PotentialAllocation.where(:task_id => task)

    records.each do |record|
      if record.capacity <= resources[record.team_id]
        return true
      end
    end

    return true
  end

  def update_resources(start_time, end_time, team_id, capacity, f_times, resources)
    index = f_times.index(start_time)
    latest = index

    # update resource for the duration of the task
    loop do
      if index >= f_times.count
        break
      end

      current_time = f_times[index]

      if (current_time >= start_time) && (current_time < end_time)
        latest = index
        resources[current_time][team_id] = resources[current_time][team_id] - capacity
      else
        break
      end

      index += 1
    end

    # update set of finish times
    if f_times.include?(end_time) == false
      f_times.insert(latest + 1, end_time)
      resources[end_time] = resources[f_times[latest]].clone
      resources[end_time][team_id] = resources[end_time][team_id] + capacity
    end

    return f_times, resources
  end

  def priority_rule(tasks, rule)
    # produce an activity list based on priority rules
    activity_list = []

    if rule == "SPT"
      activity_list, task_values = SPT(tasks)
    elsif rule == "LPT"
      activity_list, task_values = LPT(tasks)
    elsif rule == "MIS"
      activity_list, task_values = MIS(tasks)
    elsif rule == "MTS"
      activity_list, task_values = MTS(tasks)
    elsif rule == "LNRJ"
      activity_list, task_values = LNRJ(tasks)
    elsif rule == "GRPW"
      activity_list, task_values = GRPW(tasks)
    elsif rule == "EST"
      activity_list, task_values = EST(tasks)
    elsif rule == "EFT"
      activity_list, task_values = EFT(tasks)
    elsif rule == "LST"
      activity_list, task_values = LST(tasks)
    elsif rule == "LFT"
      activity_list, task_values = LFT(tasks)
    elsif rule == "MSLK"
      activity_list, task_values = MSLK(tasks)
    elsif rule == "GRWC"
      activity_list, task_values = GRWC(tasks)
    elsif rule == "GCRWC"
      activity_list, task_values = GCRWC(tasks)
    end

    return fix_activity_list(activity_list, [], {}), task_values
  end

  def sample_probabilities(decision_set, priority_values, sampling, bias)
    # defines probabilities for each task in the decision set
    probabilities = {}

    if sampling == "random"
      decision_set.each do |task|
        probabilities[task] = (1.0 / decision_set.count)
      end
    elsif sampling == "biased"
      acc = 0
      decision_set.each do |task|
        acc += priority_values[task]
      end

      decision_set.each do |task|
        probabilities[task] = priority_values[task].to_f/decision_set.count
      end
    elsif sampling == "regret"
      lowest = nil
      highest = nil

      decision_set.each do |task|
        value = priority_values[task].to_f

        if lowest.nil?
          lowest = value
        elsif value < lowest
          lowest = value
        end

        if highest.nil?
          highest = value
        elsif value > highest
          highest = value
        end
      end

      regret = highest - lowest
      decision_set.each do |task|
        probabilities[task] = (regret + 1) ** (1 - bias)  # low bias -> deterministic
      end
    end

    return probabilities
  end

  def sample_task(probabilities)
    # selects a random task according to its probabilities
    probability = rand()

    probabilities.each do |k, v|
      value = probabilities[k]
      if probability <= value
        return k
      end

      probability -= value
    end
  end
end
