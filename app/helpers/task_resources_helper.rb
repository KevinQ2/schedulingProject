module TaskResourcesHelper
  def get_capacity_conflicts(project)
    text = []
    capacity_conflicts = {}

    TaskResource.where(:project_id => project).each do |resource|
      if resource.capacity > resource.human_resource.instances
        if capacity_conflicts[resource.human_resource.name] == nil
          capacity_conflicts[resource.human_resource.name] = [resource.human_resource.instances, []]
        end

        capacity_conflicts[resource.human_resource.name][1].push(resource.task.title)
      end
    end

    capacity_conflicts.keys.each do |key|
      text.push("Human resource: " + key + "(max:" + capacity_conflicts[key][0].to_s + ") - " + capacity_conflicts[key][1].to_s)
    end

    return text
  end

  def get_unallocated_conflicts(project)
    unallocated_conflicts = []

    Task.where(:project_id => project).each do |task|
      if TaskResource.where(:task_id => task.id).count == 0
        unallocated_conflicts.push(task.id)
      end
    end

    return unallocated_conflicts
  end
end
