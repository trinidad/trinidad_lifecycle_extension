begin
  require 'bundler/gem_helper'
rescue LoadError
  require 'rubygems'
  require 'bundler/gem_helper'
end
Bundler::GemHelper.install_tasks

task :default => :spec

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_opts = ['--options', 'spec/spec.opts']
  spec.spec_files = FileList['spec/**/*_spec.rb']
end
