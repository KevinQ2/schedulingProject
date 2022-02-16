module ProjectsHelper
  Person = Struct.new(:id, :time, :record)
  TaskStruct = Struct.new(:id, :time, :record)
  ScheduleStruct = Struct.new(:time, :human, :task)

  def get_schedule(project)
    human_resources = HumanResource.where(:project_id => params[:id])
    tasks = Task.where(:project_id => params[:id])

    # (id, time of finishing)
    human_queue = []
    id = 0
    human_resources.each do |human|
      i = 0

      loop do
        if i >= human.population
          break
        end

        person = Person.new
        person.id = id
        person.time = 0
        person.record = human.id
        human_queue.push(person)

        i += 1
        id += 1
      end
    end

    # (id, duration, taskID)
    task_queue = []
    tid = 0
    tasks.each do |task|
      i = 0

      loop do
        if i >= task.amount
          break
        end

        taskS = TaskStruct.new
        taskS.id = tid
        taskS.time = task.average_duration
        taskS.record = task.id
        task_queue.push(taskS)

        i += 1
        tid += 1
      end
    end

    # (time, human id, task id)
    schedule = []
    return doSchedule(human_queue, task_queue, schedule)
  end

  def doSchedule(humans, tasks, schedule)
    if tasks.count == 0
      return schedule
    end

    current_human = humans.shift
    current_task = tasks.shift

    scheduleS = ScheduleStruct.new
    scheduleS.time = current_human.time
    scheduleS.human = current_human.id
    scheduleS.task = current_task.id

    schedule.push(scheduleS)

    current_human.time = current_human.time + current_task.time
    humans.insert(binary_search(humans, current_human, 0, humans.count), current_human)

    return doSchedule(humans, tasks, schedule)
  end

  def binary_search(human, new_human, min, max)
    if min == max
      return min
    elsif min > max
      return min
    end

    mid = ((min + max) / 2).floor

    if new_human.time == human[mid].time
      return mid
    elsif new_human.time < human[mid].time
      return binary_search(human, new_human, min, mid - 1)
    else
      return binary_search(human, new_human, mid + 1, max)
    end
  end

end
