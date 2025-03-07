# frozen_string_literal: true

require 'rails/generators'
require 'rails/generators/active_record'
require 'rails/generators/base'

module Diary
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration

      source_root File.expand_path('templates', __dir__)

      desc 'Creates a Diary initializer.'

      def copy_initializer
        template 'diary.rb', 'config/initializers/diary.rb'
      end

      def create_migrations
        migration_template 'create_diary_calendar_entries.rb', 'db/migrate/create_diary_calendar_entries.rb'
        migration_template 'create_diary_calendar_invites.rb', 'db/migrate/create_diary_calendar_invites.rb'
        migration_template 'create_diary_calendar_invitees.rb', 'db/migrate/create_diary_calendar_invitees.rb'
      end

      def self.next_migration_number(dirname)
        ActiveRecord::Generators::Base.next_migration_number(dirname)
      end
    end
  end
end
