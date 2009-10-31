ROOT_DIR = File.expand_path(File.dirname(__FILE__)) unless defined? ROOT_DIR

require "rubygems"

begin
  require "vendor/dependencies/lib/dependencies"
rescue LoadError
  require "dependencies"
end

require "monk/glue"
require "haml"
require "sass"
require 'yaml'
require 'active_record'

class Main < Monk::Glue
  set :app_file, __FILE__
  use Rack::Session::Cookie

  dbconf = YAML.load_file(root_path("config", "database.yml"))[environment]
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  ActiveRecord::Base.establish_connection(dbconf)
end

# Undefine ActiveRecird Models, hack needed for reloading to work fine
class Object
  ActiveRecord::Base.send(:subclasses).each do |klass|
    remove_const klass.name.to_sym if const_defined?(klass.name.to_sym)
  end
end

# Load all application files.
Dir[root_path("app/**/*.rb")].each do |file|
  require file
end

Main.run! if Main.run?
