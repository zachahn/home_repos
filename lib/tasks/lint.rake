desc "Run all linters"
task :lint do
  require "rubocop/rake_task"
  RuboCop::RakeTask.new

  Rake::Task["eslint"].invoke
  Rake::Task["rubocop"].invoke
  puts "🎉"
end
