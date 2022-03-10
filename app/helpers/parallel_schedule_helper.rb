module ParallelScheduleHelper
  include ScheduleHelper

  def get_parallel_schedule(project, rule)
    tasks, resources = initialise_environment(project)
    activity_list = priority_rule(tasks, rule)

    return gen_parallel_schedule({}, activity_list, [0], {0 => resources})
  end

  def gen_parallel_schedule(completed, activity_list, f_times, resources)
    if activity_list.count == 0
      return completed
    elsif f_times.count == 0
      flash.alert = "Failed to allocate all tasks"
      return completed
    end

    current_time = f_times.min

    # allocate next in activity list without breaking resource constraints
    best_record = nil
    activity_list.each do |task|
      if check_precedence_feasible(completed, task) and check_resource_feasible(task, resources[current_time])
        # choose best human_resource allocation
        best_duration = nil
        best_capacity = nil

        TaskResource.where(:task_id => task).each do |record|
          if record.capacity <= resources[current_time][record.human_resource_id]
            task_id = record.task_id
            human_resource_id = record.human_resource_id
            duration = record.duration
            capacity = record.capacity

            if best_duration == nil
              best_record = record
              best_duration = duration
              best_capacity = capacity
            elsif duration < best_duration
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
      f_times.delete(current_time)
      return gen_parallel_schedule(completed, activity_list, f_times, resources)
    end

    task_id = best_record.task_id
    human_resource_id = best_record.human_resource_id
    duration = best_record.duration
    capacity = best_record.capacity

    end_time = current_time + duration

    activity_list.delete(task_id)
    completed[task_id] = [end_time, best_record.id]

    f_times, resources = update_resources(current_time, end_time, human_resource_id, capacity, f_times, resources)

    return gen_parallel_schedule(completed, activity_list, f_times, resources)
  end
end
