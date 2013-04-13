# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "image-fun"
  gem.files.include 'lib/image_fun.rb'
  gem.homepage = "http://github.com/kdmny/image-fun"
  gem.license = "MIT"
  gem.summary = %Q{A utility to download remote images and, optionally, send them to Cloudinary.}
  gem.description = %Q{A utility to download remote images and, optionally, send them to Cloudinary.}
  gem.email = "kdmny30@gmail.com"
  gem.authors = ["K$"]
  gem.version = '0.0.1'
  # dependencies defined in Gemfile
  gem.add_dependency 'cloudinary'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end


task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "image-fun #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
