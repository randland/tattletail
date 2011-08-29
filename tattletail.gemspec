# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tattletail/version"

Gem::Specification.new do |s|
  s.name        = "tattletail"
  s.version     = Tattletail::VERSION
  s.authors     = ["Nick Karpenske"]
  s.email       = ["randland@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Ruby method call observer}
  s.description = %q{Provides a method to watch specific methods and print them when they are called}

  s.rubyforge_project = "tattletail"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "fuubar"
  s.add_runtime_dependency "colorful"
end
