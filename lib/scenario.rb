require 'rom'
require 'pry'
require 'inflecto'
require 'forwardable'

class Scenario
  extend Forwardable
  def_delegators :rom, :command, :relation

  NOOP = -> { }

  attr_reader :__name

  def initialize(name)
    @__name = name
  end

  def rom
    @rom ||= ROM.env
  end

  def f
    Functions[*args]
  end

  def reset!
    __run_teardown
    __run_setup
  end

  def to_s
    @__name
  end

  def __run
    __run_setup
    Pry.start(self, prompt_name: "#{@__name} ")
  ensure
    __run_teardown
  end

  def __run_setup
    puts "Running setup: #{@__name}..."
    _proc = self.class.instance_variable_get(:@setup) || NOOP
    instance_exec(&_proc)
  end

  def __run_teardown
    puts "Running teardown: #{@__name}..."
    _proc = self.class.instance_variable_get(:@teardown) || NOOP
    instance_exec(&_proc)
  end

  def about
    if about_str = self.class.instance_variable_get(:@about_str)
      puts about_str
    else
      puts "No about defined."
    end
  end

  # SCENARIO DSL
  class << self
    def setup(&block)
      @setup = block
    end

    def teardown(&block)
      @teardown = block
    end

    def about(about_str)
      @about_str = about_str
    end
  end

  class << self
    def run(scenario_path, &block)
      scenario = load(scenario_path)
      scenario.__run(&block)
    end

    def load(scenario_path)
      require File.expand_path(scenario_path)

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
