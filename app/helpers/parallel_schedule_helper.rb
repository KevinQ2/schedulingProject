module ParallelScheduleHelper
  include ScheduleHelper

  def get_parallel_schedule(project, rule, sampling, bias)
    tasks, resources = initialise_environment(project)
    activity_list, task_values = priority_rule(tasks, rule)

    return gen_parallel_schedule({}, activity_list, [0], {0 => resources}, task_values, sampling, bias)
  end

  def gen_parallel_schedule(completed, activity_list, f_times, resources, task_values, sampling, bias)
    if activity_list.count == 0
      return completed
    elsif f_times.count == 0
      flash.alert = "Failed to allocate all tasks"
      return completed
    end

    current_time = f_times.min

    task = nil
    if sampling == "none"
      # allocate next in activity list without breaking resource constraints
      activity_list.each do |current_task|
        if check_precedence_feasible(completed, task) and check_resource_feasible(task, resources[current_time])
          task = current_task
        end
      end
    else
      # only sample tasks in the current "decision set"
      decision_set = []
      activity_list.each do |task|
        if check_precedence_feasible(completed, task) and check_resource_feasible(task, resources[current_time])
          decision_set.push(task)
        end
      end

      probabilities = sample_probabilities(decision_set, task_values, sampling, bias)
      task = sample_task(probabilities)
    end

    # choose best team allocation
    best_record = nil
    best_duration = nil
    best_capacity = nil

    PotentialAllocation.where(:task_id => task).each do |record|
      if record.capacity <= resources[current_time][record.team_id]
        task_id = record.task_id
        team_id = record.team_id
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

    if best_record == nil
      f_times.delete(current_time)
      return gen_parallel_schedule(completed, activity_list, f_times, resources, task_values, sampling, bias)
    end

    task_id = best_record.task_id
    team_id = best_record.team_id
    duration = best_record.duration
    capacity = best_record.capacity

    end_time = current_time + duration

    activity_list.delete(task_id)
    completed[task_id] = [end_time, best_record.id]

    f_times, resources = update_resources(current_time, end_time, team_id, capacity, f_times, resources)

    return gen_parallel_schedule(completed, activity_list, f_times, resources, task_values, sampling, bias)
  end
end
