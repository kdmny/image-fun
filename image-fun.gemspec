# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require "image_fun"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "image-fun"
  s.version     = ImageFun::VERSION
  s.authors     = ["kdmny"]
  s.email       = ["kdmny30@gmail.com"]
  s.homepage    = "http://github.com/kdmny/image-fun"
  s.summary     = "A utility to download remote images and, optionally, send them to Cloudinary."
  s.description = "A utility to download remote images and, optionally, send them to Cloudinary."

  s.files         = `git ls-files`.split($/)
  s.test_files = Dir["test/**/*"]
  s.require_paths = ["lib"]
end
