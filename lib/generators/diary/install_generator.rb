# frozen_string_literal: true

require 'rails/generators/base'

module Diary
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __dir__)

      desc 'Creates a Diary initializer.'

      def copy_initializer
        template 'diary.rb', 'config/initializers/diary.rb'
      end
    end
  end
end
