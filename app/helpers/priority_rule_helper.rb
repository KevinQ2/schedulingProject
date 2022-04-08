module PriorityRuleHelper
  include ScheduleHelper

  def fix_activity_list(old, new, completed)
    if old.length == 0
      return new
    end

    found = false

    old.each do |task|
      if check_precedence_feasible(completed, task)
        new.push(task)
        completed[task] = 1
        found = true
        old.delete(task)
        break
      end
    end

    # safety measure, this should never occur
    if !found
      flash.alert = "error in producing activity list"
      return new
    end

    return fix_activity_list(old, new, completed)
  end

  # activity based
  def SPT(tasks)
    task_values = {}

    tasks.each do |task|
      record = PotentialAllocation.where(:task_id => task).first
      task_values[task] = record.duration
    end

    activity_list = []

    task_values.sort_by{|k, v| v}.each do |k, v|
      activity_list.push(k.to_s.to_i)
    end

    return activity_list, task_values
  end

  def LPT(tasks)
    temp = SPT(tasks)
    return temp[0].reverse, temp[1]
  end

  # network based
  def MIS(tasks)
    activity_list = []
    task_values = {}

    tasks.each do |task|
      task_values[task] = TaskPrecedence.where(:required_task_id => task).count
    end

    task_values.sort_by{|k, v| v}.reverse.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, task_values
  end

  def MTS(tasks)
    activity_list = []
    task_values = {}

    tasks.each do |task|
      found_tasks = Set[]
      successors = TaskPrecedence.where(:required_task_id => task)
      finished = false

      while finished == false
        finished = true
        temp = Set[]

        successors.each do |successor|
          if !found_tasks.include?(successor.task_id)
            found_tasks.add(successor.task_id)
            temp.add(successor.task_id)
            finished = false
          end
        end

        successors = TaskPrecedence.where(:required_task_id => temp)
      end

      task_values[task] = found_tasks.count
    end

    task_values.sort_by{|k, v| v}.reverse.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, task_values
  end

  def LNRJ(tasks)
    activity_list = []
    task_values = {}

    tasks.each do |task|
      found_tasks = Set[]
      predecessors = TaskPrecedence.where(:task_id => task)
      successors = TaskPrecedence.where(:required_task_id => task)
      finished = false

      while finished == false
        finished = true
        temp_p = Set[]
        temp_s = Set[]

        predecessors.each do |predecessor|
          if !found_tasks.include?(predecessor.required_task_id)
            found_tasks.add(predecessor.required_task_id)
            temp_p.add(predecessor.required_task_id)
            finished = false
          end
        end

        successors.each do |successor|
          if !found_tasks.include?(successor.task_id)
            found_tasks.add(successor.task_id)
            temp_s.add(successor.task_id)
            finished = false
          end
        end

        predecessors = TaskPrecedence.where(:task_id => temp_p)
        successors = TaskPrecedence.where(:required_task_id => temp_s)
      end

      task_values[task] = tasks.count - found_tasks.count - 1
    end

    task_values.sort_by{|k, v| v}.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, task_values
  end

  def GRPW(tasks)
    activity_list = []
    task_values = {}

    tasks.each do |task|
      acc = PotentialAllocation.where(:task_id => task).first.duration
      successors = TaskPrecedence.where(:required_task_id => task)

      successors.each do |successor|
        acc += PotentialAllocation.where(:task_id => successor.task_id).first.duration
      end

      task_values[task] = acc
    end

    task_values.sort_by{|k, v| v}.reverse.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, task_values
  end

  # scheduling based
  def EST(tasks)
    activity_list = []
    task_values = {}

    tasks.each do |task|
      if task_values[task] == nil
        task_values = get_earliest_start_times(task, task_values)
      end
    end

    task_values.sort_by{|k, v| v}.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, task_values
  end

  def EFT(tasks)
    activity_list = []
    task_values = {}

    tasks.each do |task|
      if task_values[task] == nil
        task_values = get_earliest_start_times(task, task_values)
      end
    end

    task_values.keys.each do |key|
      task_values[key] += PotentialAllocation.where(:task_id => key).first.duration
    end

    task_values.sort_by{|k, v| v}.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, task_values
  end

  def LST(tasks)
    activity_list = []
    task_values = {}

    # get earliest start times
    tasks.each do |task|
      if task_values[task] == nil
        task_values = get_earliest_start_times(task, task_values)
      end
    end

    # transform to earliest finish time
    task_values.keys.each do |key|
      task_values[key] += PotentialAllocation.where(:task_id => key).first.duration
    end

    # get latest finish times
    latest_starts = get_latest_finish_times(task_values, {})

    # transform to latest start times
    latest_starts.keys.each do |key|
      latest_starts[key] -= PotentialAllocation.where(:task_id => key).first.duration
    end

    latest_starts.sort_by{|k, v| v}.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, latest_starts
  end

  def LFT(tasks)
    activity_list = []
    task_values = {}

    # get earliest start times
    tasks.each do |task|
      if task_values[task] == nil
        task_values = get_earliest_start_times(task, task_values)
      end
    end

    # transform to earliest finish time
    task_values.keys.each do |key|
      task_values[key] += PotentialAllocation.where(:task_id => key).first.duration
    end

    # get latest finish times
    latest_finish_times = get_latest_finish_times(task_values, {})

    latest_finish_times.sort_by{|k, v| v}.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, latest_finish_times
  end

  def MSLK(tasks)
    activity_list = []
    earliest_finish_times = {}

    # get earliest start times
    tasks.each do |task|
      if earliest_finish_times[task] == nil
        earliest_finish_times = get_earliest_start_times(task, earliest_finish_times)
      end
    end

    # transform to earliest finish time
    earliest_finish_times.keys.each do |key|
      earliest_finish_times[key] += PotentialAllocation.where(:task_id => key).first.duration
    end

    # get latest finish times
    latest_finish_times = get_latest_finish_times(earliest_finish_times, {})

    # get slack values
    slack_values = {}
    tasks.each do |task|
      slack_values[task] = latest_finish_times[task] - earliest_finish_times[task]
    end

    slack_values.sort_by{|k, v| v}.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, slack_values
  end

  # resource based
  def GRWC(tasks)
    activity_list = []
    task_values = {}

    tasks.each do |task|
      record = PotentialAllocation.where(:task_id => task).first
      task_values[task] = record.duration * record.capacity
    end

    task_values.sort_by{|k, v| v}.reverse.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, task_values
  end

  def GCRWC(tasks)
    activity_list = []
    task_values = {}

    tasks.each do |task|
      record = PotentialAllocation.where(:task_id => task).first
      acc = record.duration * record.capacity

      successors = TaskPrecedence.where(:required_task_id => task)
      successors.each do |successor|
        record = PotentialAllocation.where(:task_id => successor.task_id).first
        acc += record.duration * record.capacity
      end

      task_values[task] = acc
    end

    task_values.sort_by{|k, v| v}.reverse.each do |k, v|
      activity_list.push(k)
    end

    return activity_list, task_values
  end

  # computation helpers
  def get_earliest_start_times(current_task, earliest_starts)
    latest_start = 0
    predecessors = TaskPrecedence.where(:task_id => current_task)

    predecessors.each do |predecessor|
      # compute if not already computed
      if earliest_starts[predecessor.required_task_id] == nil
        earliest_starts = get_earliest_start_times(predecessor.required_task_id, earliest_starts)
      end

      start_time = earliest_starts[predecessor.required_task_id] + PotentialAllocation.where(:task_id => predecessor.required_task_id).first.duration

      if start_time > latest_start
        latest_start = start_time
      end
    end

    earliest_starts[current_task] = latest_start
    return earliest_starts
  end

  def get_latest_finish_times(earliest_finish_times, latest_finish_times)
    earliest_finish_times.sort_by{|k, v| v}.reverse.each do |k, v|
      successors = TaskPrecedence.where(:required_task_id => k)

      if successors.count == 0
        latest_finish_times[k] = v
      else
        earliest_start = nil

        successors.each do |successor|
          start_time = latest_finish_times[successor.task_id] - PotentialAllocation.where(:task_id => successor.task_id).first.duration

          if earliest_start == nil
            earliest_start = start_time
          elsif start_time < earliest_start
            earliest_start = start_time
          end
        end

        latest_finish_times[k] = earliest_start
      end

    end

    return latest_finish_times
  end
end
