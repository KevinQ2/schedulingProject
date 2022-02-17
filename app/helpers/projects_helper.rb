module ProjectsHelper
  Person = Struct.new(:id, :time, :instance_id)
  TaskStruct = Struct.new(:id, :duration, :weight, :count, :instances)
  ScheduleStruct = Struct.new(:time, :human_id, :human_instance_id, :task_id, :task_instance_id)

  def get_schedule(project)
    human_resources = HumanResource.where(:project_id => params[:id])
    tasks = Task.where(:project_id => params[:id])

    # (id, time of finishing)
    human_queue = []
    human_resources.each do |human|
      instance_id = 0

      loop do
        if instance_id >= human.instances
          break
        end

        person = Person.new
        person.id = human.id
        person.time = 0
        person.instance_id = instance_id
        human_queue.push(person)

        instance_id += 1
      end
    end

    # (id, duration, instances)
    task_queue = []

    tasks.each do |task|
      taskS = TaskStruct.new
      taskS.id = task.id
      taskS.duration = task.average_duration
      taskS.weight = getTaskWeight(task)
      taskS.count = 0
      taskS.instances = task.instances
      task_queue.insert(binary_searchT(task_queue, taskS, 0, task_queue.count), taskS)
    end

    task_queue = task_queue.reverse()

    # (time, human id, task id)
    schedule = []
    return doSchedule(human_queue, task_queue, schedule)
  end

  def doSchedule(humans, tasks, schedule)
    if tasks.count == 0
      return schedule
    end

    current_human = humans.shift
    tasks[0].count += 1

    scheduleS = ScheduleStruct.new
    scheduleS.time = current_human.time
    scheduleS.human_id = current_human.id
    scheduleS.human_instance_id = current_human.instance_id
    scheduleS.task_id = tasks[0].id
    scheduleS.task_instance_id = tasks[0].count
    schedule.push(scheduleS)

    # update human resource queue
    current_human.time = current_human.time + tasks[0].duration
    humans.insert(binary_search(humans, current_human, 0, humans.count), current_human)

    if tasks[0].count == tasks[0].instances
      tasks.shift
    end

    return doSchedule(humans, tasks, schedule)
  end

  def getTaskWeight(task)
    precedences = TaskPrecedence.where(:required_task_id => task.id)
    max_weight = 0

    precedences.each do |prec_task|
      temp_weight = getTaskWeight(Task.find(prec_task.task_id))

      if temp_weight > max_weight
        max_weight = temp_weight
      end
    end

    return task.average_duration + max_weight
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

  def binary_searchT(task, new_task, min, max)
    if min == max
      return min
    elsif min > max
      return min
    end

    mid = ((min + max) / 2).floor

    if new_task.weight == task[mid].weight
      return mid
    elsif new_task.weight < task[mid].weight
      return binary_search(task, new_task, min, mid - 1)
    else
      return binary_search(task, new_task, mid + 1, max)
    end
  end

end
