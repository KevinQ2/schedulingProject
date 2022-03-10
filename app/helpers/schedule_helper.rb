module ScheduleHelper
  using PriorityRuleHelper

  def initialise_environment(project)
    decision_set = []
    tasks = []

    Task.where(:project_id => project.id).each do |task|
      tasks.push(task.id)
    end

    resources = {}

    HumanResource.where(:project_id => project.id).each do |human_resource|
      resources[human_resource.id] = human_resource.instances
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
    records = TaskResource.where(:task_id => task)

    records.each do |record|
      if record.capacity <= resources[record.human_resource_id]
        return true
      end
    end

    return true
  end

  def update_resources(start_time, end_time, human_resource_id, capacity, f_times, resources)
    index = f_times.index(start_time)
    latest = index

    loop do
      if index >= f_times.count
        break
      end

      current_time = f_times[index]

      if (current_time >= start_time) && (current_time < end_time)
        latest = index
        resources[current_time][human_resource_id] = resources[current_time][human_resource_id] - capacity
      else
        break
      end

      index += 1
    end

    if f_times.include?(end_time) == false
      f_times.insert(latest + 1, end_time)
      resources[end_time] = resources[f_times[latest]].clone
      resources[end_time][human_resource_id] = resources[end_time][human_resource_id] + capacity
    end

    return f_times, resources
  end

  def priority_rule(tasks, rule)
    activity_list = nil

    if rule == "SPT"
      activity_list = SPT(tasks)
    elsif rule == "LPT"
      activity_list = LPT(tasks)
    elsif rule == "MIS"
      activity_list = MIS(tasks)
    elsif rule == "MTS"
      activity_list = MTS(tasks)
    elsif rule == "LNRJ"
      activity_list = LNRJ(tasks)
    elsif rule == "GRPW"
      activity_list = GRPW(tasks)
    elsif rule == "EST"
      activity_list = EST(tasks)
    elsif rule == "EFT"
      activity_list = EFT(tasks)
    elsif rule == "LST"
      activity_list = LST(tasks)
    elsif rule == "LFT"
      activity_list = LFT(tasks)
    elsif rule == "MSLK"
      activity_list = MSLK(tasks)
    elsif rule == "GRWC"
      activity_list = GRWC(tasks)
    elsif rule == "GCRWC"
      activity_list = GCRWC(tasks)
    end

    return fix_activity_list(activity_list, [], {})
  end
end
