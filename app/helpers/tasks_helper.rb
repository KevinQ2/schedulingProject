module TasksHelper
  def get_cycles(project)
    covered_tasks = Set[]
    all_cycles = []

    tasks = Task.where(:project_id => project)

    tasks.each do |task|
      # ignore already searched tasks
      if !covered_tasks.include?(task.id)
        covered, cycles = compute_cycles(covered_tasks, [], task.id, [])
        covered_tasks.merge(covered)
        all_cycles += cycles
      end
    end

    return all_cycles
  end

  def compute_cycles(covered_tasks, path, current_task, cycles_found)
    if path.include?(current_task)
      # a cycle is found
      new_cycle = path[path.index(current_task), path.count].push(current_task)
      temp = new_cycle.to_set

      # do not add duplicate cycles
      cycles_found.each do |cycle|
        if cycle.to_set == temp
          return covered_tasks, cycles_found
        end
      end

      cycles_found.push(new_cycle)
      return covered_tasks, cycles_found
    elsif covered_tasks.include?(current_task)
      # cycles in covered tasks are already identified
      return covered_tasks, cycles_found
    end

    # update path, and check precedences
    covered_tasks.add(current_task)
    path.push(current_task)

    TaskPrecedence.where(:task_id => current_task).each do |precedence|
      covered_tasks, cycles_found = compute_cycles(covered_tasks, path.clone, precedence.required_task_id, cycles_found)
    end

    return covered_tasks, cycles_found
  end
end
