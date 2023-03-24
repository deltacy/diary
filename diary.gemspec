# frozen_string_literal: true

require_relative 'lib/diary/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 3.1.0'
  spec.name        = 'diary'
  spec.version     = Diary::VERSION
  spec.authors     = ['Despo Pentara']
  spec.email       = ['despo@extractmethod.com']
  spec.homepage    = 'https://github.com/delltacy/diary'
  spec.summary     = 'Calendar integration for rails.'
  spec.description = 'Set availability and schedule things.'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/delltacy/diary'
  spec.metadata['changelog_url'] = 'https://github.com/delltacy/diary'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  end

  spec.add_dependency 'rails', '>= 7.0.4.3'
end
