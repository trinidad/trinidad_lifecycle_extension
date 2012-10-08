# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "trinidad_lifecycle_extension/version"

Gem::Specification.new do |s|
  s.name              = 'trinidad_lifecycle_extension'
  s.version           = Trinidad::Extensions::Lifecycle::VERSION
  s.rubyforge_project = 'trinidad_lifecycle_extension'

  s.summary     = "Add lifecycle listeners to Trinidad"
  s.description = "Add lifecycle listeners to Trinidad's server or the web applications that run on it."

  s.authors  = ["David Calavera"]
  s.email    = 'calavera@apache.org'
  s.homepage = 'http://github.com/trinidad/trinidad_lifecycle_extension'

  s.rdoc_options = ["--charset=UTF-8"]
  s.extra_rdoc_files = %w[ README.md LICENSE ]
  
  s.require_paths = %w[lib]
  s.files = `git ls-files`.split("\n")
  s.test_files = s.files.select { |path| path =~ /^spec\/*_spec\.rb/ }

  s.add_dependency('trinidad', '>= 1.4.1')
  s.add_development_dependency('rake')
  s.add_development_dependency('rspec', '>= 2.8.0')
  s.add_development_dependency('mocha')
end