# frozen-string-literal: true

require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push '.'
  t.libs.push 'spec'
  t.pattern = 'specs/**/*_spec.rb'
  t.warning = false
  t.verbose = true
end

task default: :test

desc 'Generates a coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end
