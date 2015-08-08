require 'rom-sql'
require 'support'

class Basic < Scenario
  setup do
    ROM.setup(:sql, 'postgres://localhost/about-rom')

    require 'basic/create_tables'
    require 'basic/setup_rom'

    ROM.finalize
  end

  teardown do
    require 'basic/drop_tables'
  end

  def seed
    load File.expand_path('../basic/seed.rb', __FILE__)
  end
end
