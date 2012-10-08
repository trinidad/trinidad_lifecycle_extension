begin
  require 'bundler/gem_helper'
rescue LoadError
  require 'rubygems'
  require 'bundler/gem_helper'
end
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['--color', "--format documentation"]
end

task :default => :spec
