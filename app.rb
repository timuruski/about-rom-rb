require 'bundler/setup'

require_relative 'drop_db_tables'
require_relative 'create_db_tables'
require_relative 'rom'
require_relative 'models'

ROM.finalize.env.tap do |rom|
  rom.command
end
