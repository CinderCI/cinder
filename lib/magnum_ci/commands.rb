$:.push File.expand_path('../', __FILE__)

require 'dotenv'
Dotenv.load File.join(ENV['JENKINS_HOME'] || '.', '.env.ios')

require 'extlib/string'
require 'openssl'
require 'plist'
require 'external_commands'

require 'commands/build'
require 'commands/setup'
require 'commands/lint'
