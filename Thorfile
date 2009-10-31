class Monk < Thor
  include Thor::Actions

  desc "test", "Run all tests"
  def test
    verify_config(:test)

    $:.unshift File.join(File.dirname(__FILE__), "test")

    Dir['test/**/*_test.rb'].each do |file|
      load file unless file =~ /^-/
    end
  end

  desc "stories", "Run user stories."
  method_option :pdf, :type => :boolean
  def stories
    $:.unshift(Dir.pwd, "test")

    ARGV << "-r"
    ARGV << (options[:pdf] ? "stories-pdf" : "stories")
    ARGV.delete("--pdf")

    Dir["test/stories/*_test.rb"].each do |file|
      load file
    end
  end

  desc "start ENV", "Start Monk in the supplied environment"
  def start(env = ENV["RACK_ENV"] || "development")
    verify_config(env)

    exec "env RACK_ENV=#{env} ruby init.rb"
  end

  desc "copy_example EXAMPLE, TARGET", "Copies an example file to its destination"
  def copy_example(example, target = target_file_for(example))
    File.exists?(target) ? return : say_status(:missing, target)
    File.exists?(example) ? copy_file(example, target) : say_status(:missing, example)
  end

private

  def self.source_root
    File.dirname(__FILE__)
  end

  def target_file_for(example_file)
    example_file.sub(".example", "")
  end

  def verify_config(env)
    verify "config/settings.example.yml"
    verify "config/database.example.yml"
  end

  def verify(example)
    copy_example(example) unless File.exists?(target_file_for(example))
  end

end

class DB < Thor
  desc "migrate", "Runs ActiveRecord migrations"
  def migrate
    load 'init.rb'
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate("db/migrate",
                                   ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
    dump_schema
  end

  desc "create_migration", "Creates an ActiveRecord migration"
  def create_migration(name, version=nil)
    migrations_dir = File.join("db", "migrate")
    version ||= Time.now.utc.strftime("%Y%m%d%H%M%S")
    filename = "#{version}_#{name}.rb"
    migration_name = name.gsub(/_(.)/) { $1.upcase }.gsub(/^(.)/) { $1.upcase }

    FileUtils.mkdir_p(migrations_dir)

    open(File.join(migrations_dir, filename), 'w') do |f|
      f << (<<-EOS).gsub("      ", "")
      class #{migration_name} < ActiveRecord::Migration
        def self.up
        end

        def self.down
        end
      end
      EOS
    end
  end

  desc "dump_schema", "Creates db/schema.db"
  def dump_schema(schema_file="#{File.dirname(__FILE__)}/db/schema.rb")
    load 'init.rb'
    require 'active_record/schema_dumper'

    File.open(schema_file, "w") do |file|
      ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
    end
  end
end
