require 'bundler/setup'

require_relative 'models'
require_relative 'setup_rom'
require_relative 'db/drop_tables'
require_relative 'db/create_tables'

ROM.env.tap do |rom|

end
