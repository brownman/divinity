require 'rake/testtask'
namespace :test do
  desc 'Run all unit tests'
  Rake::TestTask.new(:unit => [:check_dependencies]) do |t|
    t.libs << "lib"
    t.libs << "test"
    t.test_files = "test/unit/**/*_test.rb"
    t.verbose = true
  end

  desc "Run all functional tests"
  Rake::TestTask.new(:functional => [:check_dependencies]) do |t|
    t.libs << "lib"
    t.libs << "test"
    t.test_files = "test/engine/**/*_test.rb"
    t.verbose = true
  end

  desc 'Run all tests'
  task :all do |t|
    Rake::Task['test:unit'].invoke
    Rake::Task['test:functional'].invoke
  end
end

task :test => "test:all"
task :default => "test:all"
