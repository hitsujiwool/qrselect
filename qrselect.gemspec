# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "qrselect/version"

Gem::Specification.new do |s|
  s.name        = "qrselect"
  s.version     = QRSelect::VERSION
  s.authors     = ["hitsujiwool"]
  s.email       = ["utatanenohibi@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{}
  s.description = %q{}

  s.rubyforge_project = "qrselect"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rb-fsevent"
  s.add_development_dependency "terminal-notifier-guard"
  s.add_dependency "nokogiri"
  s.add_dependency "mysql2"
  # s.add_runtime_dependency "rest-client"
end
