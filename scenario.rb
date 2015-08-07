require 'rom'
require 'inflecto'
require 'forwardable'

class Scenario
  extend Forwardable
  def_delegators :rom, :command, :relation

  NOOP = -> { }

  def initialize(name)
    @__name = name
  end

  def rom
    @rom ||= ROM.env
  end

  def __run
    __run_setup
    yield self if block_given?
  ensure
    __run_teardown
  end

  def __run_setup
    puts "Running setup: #{@__name}..."
    _proc = self.class.instance_variable_get(:@setup) || NOOP
    _proc.call
  end

  def __run_teardown
    puts "Running teardown: #{@__name}..."
    _proc = self.class.instance_variable_get(:@teardown) || NOOP
    _proc.call
  end

  # SCENARIO DSL
  class << self
    def setup(&block)
      @setup = block
    end

    def teardown(&block)
      @teardown = block
    end
  end

  class << self
    def run(scenario_path, &block)
      scenario = load(scenario_path)
      scenario.__run(&block)
    end

    def load(scenario_path)
      require_relative scenario_path

      scenario_name = File.basename(scenario_path)
      scenario_class = @scenarios[scenario_name]
      scenario_class.new(scenario_name)
    end

    # Store subclasses under a consistent name.
    def inherited(subclass)
      @scenarios ||= {}
      @scenarios[Inflecto.underscore(subclass.name)] = subclass
    end
  end
end
