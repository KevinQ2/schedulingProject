module ProjectsHelper
  include TasksHelper
  include TaskResourcesHelper
  include SerialScheduleHelper
  include ParallelScheduleHelper

  def generate_schedule(project, scheme, rule)
    if scheme == "Serial"
      return get_serial_schedule(project, rule)
    elsif scheme == "Parallel"
      return get_parallel_schedule(project, rule)
    else
      flash.alert = "Invalid scheme"
    end
  end
end
