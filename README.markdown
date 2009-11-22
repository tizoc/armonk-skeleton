Monk skeleton with ActiveRecord.
================================

Thor tasks:
-----------

    db:migrate          # Runs ActiveRecord migrations. If the VERSION
                        # environment variable is set, its value is used as the
                        # version to be migrated to. After the migration is
                        # complete db/schema.rb is regenerated

    db:create_migration # Creates an ActiveRecord migration

    db:dump_schema      # Creates db/schema.rb
