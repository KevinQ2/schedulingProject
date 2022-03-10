module SerialScheduleHelper
  include ScheduleHelper

  def get_serial_schedule(project, rule)
    tasks, resources = initialise_environment(project)
    activity_list = priority_rule(tasks, rule)
    return gen_serial_schedule({}, activity_list, [0], {0 => resources}, tasks.count)
  end

  def gen_serial_schedule(completed, activity_list, f_times, resources, count)
    if count < 0
      flash.alert = "Timed out"
      return completed
    elsif activity_list.count == 0
      return completed
    end

    # allocate next in activity list without breaking resource constraints
    best_record = nil
    best_start_time = nil

    activity_list.each do |task|
      if check_precedence_feasible(completed, task)
        # choose best human_resource allocation
        best_duration = nil
        best_capacity = nil

        last_prec_time = get_last_prec_time(task, completed)

        TaskResource.where(:task_id => task).each do |record|
          task_id = record.task_id
          human_resource_id = record.human_resource_id
          duration = record.duration
          capacity = record.capacity

          start_time = get_early_employee_time(last_prec_time, human_resource_id, duration, capacity, f_times, resources)

          if best_start_time == nil
            best_record = record
            best_start_time = start_time
            best_duration = duration
            best_capacity = capacity
          elsif start_time < best_start_time
            best_record = record
            best_start_time = start_time
            best_duration = duration
            best_capacity = capacity
          elsif start_time == best_start_time
            if duration < best_duration
              best_record = record
              best_duration = duration
              best_capacity = capacity
            elsif duration == best_duration
              if capacity < best_capacity
                best_record = record
                best_capacity = capacity
              end
            end
          end
        end

        break
      end
    end

    if best_record == nil
      flash.alert = "Failed to allocate all tasks "
      return completed
    end

    task_id = best_record.task_id
    human_resource_id = best_record.human_resource_id
    duration = best_record.duration
    capacity = best_record.capacity

    end_time = best_start_time + duration

    activity_list.delete(task_id)
    completed[task_id] = [end_time, best_record.id]

    f_times, resources = update_resources(best_start_time, end_time, human_resource_id, capacity, f_times, resources)

    return gen_serial_schedule(completed, activity_list, f_times, resources, count - 1)
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
end
