module ProjectsHelper
  def get_schedule(project)
    decision_set = []
    invalid = []

    Task.where(:project_id => project.id).each do |task|
      decision_set.push(task.id)
    end

    temp = decision_set.clone

    TaskPrecedence.where(:task_id => temp).each do |prec|
      decision_set.delete(prec.task_id)
      invalid.push(prec.task_id)
    end

    resources = {}

    HumanResource.where(:project_id => project.id).each do |human_resource|
      resources[human_resource.id] = human_resource.instances
    end

    return gen_schedule({}, decision_set, invalid, [0], {0 => resources}, 0)
  end

  def gen_schedule(completed, decision_set, invalid, f_times, resources, count)
    if decision_set.count == 0
      return completed
    end

    decision_set, invalid = update_decision_set(completed, decision_set, invalid)

    # allocate next task
    best_start_time = nil
    best_capacity = nil
    best_record = nil

    decision_set.each do |current_task|
      last_prec_time = get_last_prec_time(current_task, completed)

      TaskResource.where(:task_id => current_task).each do |record|
        task_id = record.task_id
        human_resource_id = record.human_resource_id
        duration = record.duration
        capacity = record.capacity

        start_time = get_early_employee_time(last_prec_time, human_resource_id, duration, capacity, f_times, resources)

        if best_start_time == nil
          best_start_time = start_time
          best_capacity = capacity
          best_record = record
        elsif start_time < best_start_time
          best_start_time = start_time
          best_capacity = capacity
          best_record = record
        elsif (start_time == best_start_time && capacity > best_capacity)
          best_start_time = start_time
          best_capacity = capacity
          best_record = record
        end
      end
    end

    if best_record == nil
      flash.alert = "error with scheduling: " + count.to_s
      return completed
    end

    task_id = best_record.task_id
    human_resource_id = best_record.human_resource_id
    duration = best_record.duration
    capacity = best_record.capacity

    end_time = best_start_time + duration

    decision_set.delete(task_id)
    completed[task_id] = [end_time, best_record.id]

    f_times, resources = update_resources(best_start_time, end_time, human_resource_id, capacity, f_times, resources)

    return gen_schedule(completed, decision_set, invalid, f_times, resources, count + 1)
  end

  def update_decision_set(completed, decision_set, invalid)
    stack = []

    invalid.each do |task_id|
      # if precedence requirements are met
      met = true

      TaskPrecedence.where(:task_id => task_id).each do |prec|
        if completed[prec.required_task_id] == nil
          met = false
          break
        end
      end

      if met
        decision_set.push(task_id)
        stack.push(task_id)
      end
    end

    stack.each do |task|
      invalid.delete(task)
    end

    return decision_set, invalid
  end

  def get_last_prec_time(task, completed)
    last_prec_time = 0

    TaskPrecedence.where(:task_id => task).each do |prec|
      end_time = completed[prec.required_task_id][0]

      if end_time > last_prec_time
        last_prec_time = end_time
      end
    end

    return last_prec_time
  end

  def get_early_employee_time(earliest, human_resource_id, duration, capacity, f_times, resources)
    current_index = f_times.index(earliest)
    start_time = nil
    time_acc = 0

    # get valid start time which maintains resource demand throughout duration
    # last is guaranteed to have enough resources
    while (current_index < f_times.count && time_acc < duration)
      current_time = f_times[current_index]
      current_caps = resources[current_time]

      if capacity <= current_caps[human_resource_id]
        if start_time == nil
          start_time = current_time
        else
          time_acc = current_time - start_time
        end
      else
        time_acc = 0
        start_time = nil
      end

      current_index += 1
    end

    return start_time
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
end
