require 'pry'

class Console < SimpleDelegator
  PROMPT = proc { |_, _, _| 'ROM: ' }

  def self.start(rom_env)
    new(rom_env).tap do |console|
      Pry.start(console, prompt: PROMPT)
    end
  end
end
