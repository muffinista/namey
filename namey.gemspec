# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "namey/version"

Gem::Specification.new do |s|
  s.name        = "namey"
  s.version     = Namey::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Colin Mitchell"]
  s.email       = ["colin@muffinlabs.com"]
  s.homepage    = "https://github.com/muffinista/namey"
  s.summary     = %q{Simple name generator based on US Census Data}
  s.description = %q{Simple name generator, which can generate male/female names based on US Census Data}

  s.rubyforge_project = "namey"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sequel>, [">= 0"])
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])      
    else
      s.add_dependency(%q<sequel>, [">= 0"])
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<sequel>, [">= 0"])
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end


# http://www.census.gov/genealogy/names/
