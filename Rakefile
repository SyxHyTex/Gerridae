require 'rake/clean'

# "Launch testing suite (RSpec)."
namespace :test do
  
  desc "Run all global and local tests."
  task :default do
    sh 'rspec'
  end

  desc "Only test gerridae.rb"
  task :gerridae do
    sh 'rspec lib/gerridae'
  end
end
