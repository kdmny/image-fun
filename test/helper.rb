require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'image_fun'

class Test::Unit::TestCase
end

class TestModel < ActiveRecord::Base
  has_fun_with_remote_images :column_name => :img
  has_fun_with_cloudinary_images :column_name => :img
  attr_accessor :img #this would be provided by paperclip or carrierwave
  attr_accessor :image_remote_url #this would be provided by the migration
  attr_accessor :img_file_name #this would be provided by the migration
  attr_accessor :img_updated_at #this would be provided by the migration
  attr_accessor :img_file_size #this would be provided by the migration
end
ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => ':memory:'
)
ActiveRecord::Schema.define do
  self.verbose = false
  create_table :test_models, :force => true do |t|
    t.text :image_remote_url
  end
end
require "mocha/setup"
