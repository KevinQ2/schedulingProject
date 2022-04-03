module SerialScheduleHelper
  include ScheduleHelper

  class Schedule
    attr_accessor :schedule, :initial_activity_list, :assignment_order, :length, :running_time

    def initialise()
      self.initial_activity_list = []
      self.assignment_order = []
      self.schedule = {}
      self.running_time = 0
    end
  end

  def get_serial_priority_schedule(project, rule, sampling, bias)
    tasks, resources = initialise_environment(project)
    activity_list, task_values = priority_rule(tasks, rule)
    return gen_serial_schedule({}, activity_list, [0], {0 => resources}, tasks.count, task_values, sampling, bias)
  end

  # same as above, but activity list is already known and no sampling
  def get_serial_activity_schedule(project, activity_list)
    project = Project.find(project)
    tasks, resources = initialise_environment(project)
    return gen_serial_schedule({}, activity_list, [0], {0 => resources}, tasks.count, nil, nil, nil)
  end

  def gen_serial_schedule(completed, activity_list, f_times, resources, count, task_values, sampling, bias)
    if count < 0
      flash.alert = "Timed out"
      return completed
    elsif activity_list.count == 0
      return completed
    end

    # select next task to be allocated
    task = nil
    if sampling == "none"
      # activity list is assumed to follow precedence feasibility
      task = activity_list[0]
    else
      # only sample tasks in the current "decision set"
      decision_set = []
      activity_list.each do |task|
        if check_precedence_feasible(completed, task)
          decision_set.push(task)
        end
      end

      probabilities = sample_probabilities(decision_set, task_values, sampling, bias)
      task = sample_task(probabilities)
    end

    last_prec_time = get_last_prec_time(task, completed)

    # choose best team allocation
    best_record = nil
    best_start_time = nil
    best_duration = nil
    best_capacity = nil

    PotentialAllocation.where(:task_id => task).each do |record|
      task_id = record.task_id
      team_id = record.team_id
      duration = record.duration
      capacity = record.capacity

      start_time = get_early_employee_time(last_prec_time, team_id, duration, capacity, f_times, resources)

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

    if best_record == nil
      #flash.alert = "Failed to allocate all tasks "
      #flash.alert = task
      return completed
    end

    task_id = best_record.task_id
    team_id = best_record.team_id
    duration = best_record.duration
    capacity = best_record.capacity

    end_time = best_start_time + duration

    activity_list.delete(task_id)
    completed[task_id] = [end_time, best_record.id]

    f_times, resources = update_resources(best_start_time, end_time, team_id, capacity, f_times, resources)

    return gen_serial_schedule(completed, activity_list, f_times, resources, count - 1, task_values, sampling, bias)
  end

  def get_last_prec_time(task, completed)
    # get earliest precedence feasible time
    last_prec_time = 0

    TaskPrecedence.where(:task_id => task).each do |prec|
      end_time = completed[prec.required_task_id][0]

      if end_time > last_prec_time
        last_prec_time = end_time
      end
    end

    return last_prec_time
  end

  def get_early_employee_time(earliest, team_id, duration, capacity, f_times, resources)
    current_index = f_times.index(earliest)
    start_time = nil
    time_acc = 0

    # get valid start time which maintains resource demand throughout duration
    # last is guaranteed to have enough resources
    while (current_index < f_times.count && time_acc < duration)
      current_time = f_times[current_index]
      current_caps = resources[current_time]

      if capacity <= current_caps[team_id]
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
