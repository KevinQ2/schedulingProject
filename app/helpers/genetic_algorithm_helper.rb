module GeneticAlgorithmHelper
  include SerialScheduleHelper

  # algorithm inspired by chitrankmishra's Genetic Algorithm implementation for the Travelling Salesman Problem
  # https://www.geeksforgeeks.org/traveling-salesman-problem-using-genetic-algorithm/
  @project = nil
  @vertices = 0
  @genes = []
  START = 0
  POP_SIZE = 5
  INT_MAX = 100000

  class Individual
    attr_accessor :gnome, :fitness

    def initialise()
      self.gnome = []
      self.fitness = 0
    end
  end

  def get_genetic_schedule(project_i)
    @project = project_i.id
    @genes = []

    Task.where(:project_id => @project).each do |task|
      @genes.push(task.id)
    end

    @vertices = @genes.count
    return utility_function()
  end

  def mutate_gene(gnome)
    # swap 2 random genes
    valids = (0...gnome.count).to_a

    while valids.count > 0
      gene_a = valids[rand(0...valids.count)]
      swappables_a = get_swappables(gnome, gene_a)

      # try all potential swapping candidates
      while swappables_a.count > 0
        gene_b = swappables_a[rand(0...swappables_a.count)]
        swappables_b = get_swappables(gnome, gene_b)

        if swappables_b.include?(gene_a)
          temp = gnome[gene_a]
          gnome[gene_a] = gnome[gene_b]
          gnome[gene_b] = temp
          return gnome
        else
          swappables_a.delete(gene_b)
        end
      end

      valids.delete(gene_a)
    end

    return nil
  end

  def get_swappables(gnome, gene)
    # get list of indexes where gene is precedence feasible
    valids = []

    precedences = TaskPrecedence.where(:task_id => gnome[gene])
    successors = TaskPrecedence.where(:required_task_id => gnome[gene])

    earliest = -1
    latest = gnome.count

    precedences.each do |precedence|
      temp = gnome.index(precedence.required_task_id)
      if temp > earliest
        earliest = temp
      end
    end

    successors.each do |successor|
      temp = gnome.index(successor.task_id)
      if temp < latest
        latest = temp
      end
    end

    swappables = ((earliest + 1)...latest).to_a
    swappables.delete(gene)

    return swappables
  end

  def create_gnome()
    gnome = []

    valids = []
    invalids = []

    # initial precedence feasible tasks
    @genes.each do |gene|
      if TaskPrecedence.where(:task_id => gene).count == 0
        valids.push(gene)
      else
        invalids.push(gene)
      end
    end

    while true
      if gnome.count == @vertices
        break
      end

      gene = valids[rand(0...valids.count)]
      if !gnome.include?(gene)
        gnome.push(gene)
        valids, invalids = update_valid(gnome, valids, invalids)
      end
    end

    return gnome
  end

  def update_valid(completed, valids, invalids)
    # updates which genes are feasible
    temp = []

    invalids.each do |gene|
      feasible = true

      TaskPrecedence.where(:task_id => gene).each do |precedence|
        if !completed.include?(precedence.required_task_id)
          feasible = false
          break
        end
      end

      if feasible
        temp.push(gene)
      end
    end

    temp.each do |gene|
      valids.push(gene)
      invalids.delete(gene)
    end

    return valids, invalids
  end

  def cal_fitness(gnome)
    i = 0

    while i < gnome.count
      completed = gnome[0, i]
      task = gnome[i]
      TaskPrecedence.where(:task_id => task).each do |precedence|
        if !completed.include?(precedence.required_task_id)
          return INT_MAX
        end
      end

      i += 1
    end

    schedule = get_serial_activity_schedule(@project, gnome.clone)
    return schedule.max_by{|k, v| v[0]}[1][0]
  end

  def cooldown(temp)
    return (90 * temp) / 100
  end

  def utility_function()
    gen = 1
    gen_thres = 50
    population = []
    best_gnome = nil
    messages = []

    messages.push("Initial population:","Gnome   FITNESS VALUE")

    i = 0
    while i < POP_SIZE
      temp = Individual.new
      temp.gnome = create_gnome()
      temp.fitness = cal_fitness(temp.gnome)
      population.append(temp)

      messages.push(population[i].gnome.map{|k| Task.find(k).title}.to_s + "  " + population[i].fitness.to_s)
      i += 1
    end

    found = false
    temperature = 10000

    while temperature > 1000 and gen <= gen_thres
      messages.push("Current temp: " + temperature.to_s)
      messages.push("Generation" + gen.to_s)
      messages.push("GNOME FITNESS VALUE")

      new_population = []
      i = 0
      while i < POP_SIZE
        p1 = population[i]

        while true
          new_g = mutate_gene(p1.gnome)
          new_gnome = Individual.new
          new_gnome.gnome = new_g
          new_gnome.fitness = cal_fitness(new_gnome.gnome)

          if new_gnome.fitness <= population[i].fitness
            new_population.append(new_gnome)

            if best_gnome.nil?
              best_gnome = new_gnome
            elsif new_gnome.fitness < best_gnome.fitness
              best_gnome = new_gnome
            end

            break
          else
            prob = 2.7 ** (-1 * ((new_gnome.fitness - population[i].fitness) / temperature))

            if prob > 0.5
              new_population.append(new_gnome)
              break
            end
          end
        end

        messages.push(population[i].gnome.map{|k| Task.find(k).title}.to_s + " " + population[i].fitness.to_s)

        i += 1
      end

      temperature = cooldown(temperature)
      population = new_population

      gen += 1
    end

    return eval_gnome(best_gnome.gnome), messages
  end

  def eval_gnome(gnome)
    return get_serial_activity_schedule(@project, gnome)
  end
end
