Monk skeleton with ActiveRecord.
================================

Thor tasks:
-----------

    db:migrate          # Runs ActiveRecord migrations. If the VERSION
                        # environment variable is set, its value is used as the
                        # version to be migrated to. After the migration is
                        # complete db/schema.rb is regenerated

    db:create_migration # Creates an ActiveRecord migration, takes the migration
                        # name as a parameter. The current timestamp is used as
                        # the version.

    db:dump_schema      # Generates db/schema.rb
