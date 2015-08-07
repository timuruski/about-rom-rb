require 'rom-sql'
require 'rom-mongo'
require 'rom-redis'

# Mongo logging is noisy
Mongo::Logger.level = 3

ROM_CONFIG = {
  default: [:sql, 'postgres://localhost/rom-demo'],
  meta: [:mongo, 'mongodb://localhost/rom-demo'],
  cache: [:redis, { host: 'localhost' }]
}

ROM.setup(ROM_CONFIG)

require_relative 'models'
require_relative 'repos/users'
require_relative 'repos/posts'
require_relative 'repos/tags'
require_relative 'repos/comments'

ROM.finalize
