class WorldStats

  DEFAULT_CALCULATOR = 'mean'

  ALL_METRICS = %w(gdp population life_expectancy)

  attr_accessor :dataset

  def self.build_dataset
    [
      {:country=>"Ethiopia", :gdp=>159, :population=>222, :life_expectancy=>72},
      {:country=>"Mauritania", :gdp=>305, :population=>402, :life_expectancy=>78},
      {:country=>"Moldova", :gdp=>741, :population=>487, :life_expectancy=>67},
      {:country=>"Anguilla", :gdp=>382, :population=>314, :life_expectancy=>68},
      {:country=>"Panama", :gdp=>665, :population=>440, :life_expectancy=>53},
      {:country=>"Taiwan", :gdp=>79, :population=>39, :life_expectancy=>79},
      {:country=>"American Samoa", :gdp=>373, :population=>381, :life_expectancy=>61},
      {:country=>"Hungary", :gdp=>68, :population=>226, :life_expectancy=>75}
    ]
  end

  def initialize
    self.dataset = WorldStats.build_dataset
  end

  def gdp(options = {})
    countries = get_data_by_countries(options[:countries]) || self.dataset
    all_gdp = countries.map{|stats| stats[:gdp]}
    calculator = options[:calculator] || DEFAULT_CALCULATOR
    print_operation(calculator, 'gdp', countries)
    calculate(calculator, all_gdp)

  end

  def population(options = {})
    countries = get_data_by_countries(options[:countries]) || self.dataset
    all_population = countries.map{|stats| stats[:population]}
    calculator = options[:calculator] || DEFAULT_CALCULATOR
    print_operation(calculator, 'population', countries)
    calculate(calculator, all_population)
  end

  def life_expectancy(options = {})
    countries = get_data_by_countries(options[:countries]) || self.dataset
    all_expectancies = countries.map{|stats| stats[:life_expectancy]}
    calculator = options[:calculator] || DEFAULT_CALCULATOR
    print_operation(calculator, 'life expectancy', countries)
    calculate(calculator, all_expectancies)
  end

  def mean(options = {})
    metrics = (options[:metrics] || ALL_METRICS).map(&:to_sym)
    countries = get_data_by_countries(options[:countries]) || self.dataset

    output = {}
    print_operation('mean', metrics.join(', '), countries)
    metrics.each do |metric|
      if ALL_METRICS.include?(metric.to_s)
        output[metric] = self.send(metric, options)
      else
        p "metric #{metric} not supported, doing nothing"
      end
    end
    output
  end

  def median(options = {})
    metrics = (options[:metrics] || ALL_METRICS).map(&:to_sym)
    countries = get_data_by_countries(options[:countries]) || self.dataset

    output = {}
    print_operation('median', metrics.join(', '), countries)
    options.merge!(calculator: 'median')
    metrics.each do |metric|
      if ALL_METRICS.include?(metric.to_s)
        output[metric] = self.send(metric, options)
      else
        p "metric #{metric} not supported, doing nothing"
      end
    end
    output
  end

  private

  def print_operation(calculator, stat, countries)
    country_names = countries.map{|stats| stats[:country]}
    p "calculating #{calculator} #{stat} for #{country_names.join(', ')}"
  end

  def calculate(calculator, data)
    if data.any?
      if calculator == 'median'
        calculate_median(data)
      elsif calculator == DEFAULT_CALCULATOR
        calculate_mean(data)
      else
        #not required yet
      end
    else
      p "no data for #{calculator}, doing nothing"
      return
    end
  end

  def get_data_by_countries(countries)
    return unless countries
    self.dataset.select{|stats| countries.include?(stats[:country])}
  end



  def calculate_median(array)
    sorted = array.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end

  def calculate_mean(array)
    array.reduce(:+) / array.length.to_f
  end

end

def assert_equal(expression, result)
  if expression == result
    "TRUE"
  else
    "Expected #{expression} to equal #{result}"
  end
end

def perform
  computer = WorldStats.new

  random_subset = lambda do |key|
    max_size = computer.dataset.size
    computer.dataset.sample(Random.rand(0..max_size)).map{|d|d[key]}
  end


  p assert_equal(computer.gdp(calculator: 'median'), 339.0)
  p assert_equal(computer.gdp(calculator: 'mean'), 346.5)
   # --> e.g 128.1
  p computer.population(countries: random_subset[:country])
   # --> e.g 92.02
  p assert_equal(computer.life_expectancy, 69.125)
  # --> e.g 70.3
  p computer.mean(metrics: %w(gdp population), countries: random_subset[:country])
  # --> e.g {gdp: 444, population: 122}
  computer.median
  p assert_equal(computer.median, {gdp: 339.0 , population: 347.5, life_expectancy: 70.0})
  # --> i.e same as above, applying median to all countries over all metrics
end

perform

############ INSTRUCTIONS ############

# Write your code below the perform method.
# Your code should respond to the methods five functions demoed in the perform method.

# Every parameter is optional. The default values are the following:
# calculator --> 'mean'. Supported by the first gpd(), population(), and life_expectancy()
# countries --> all the countries in the dataset. Supported by all methods.
# metrics --> gdp, population, life_expectancy. Supported by mean() and median()

# We're looking for elegant, DRY, and readable code.

# Bonus: make a Country class whose fields are dynmically generated by the dataset.
