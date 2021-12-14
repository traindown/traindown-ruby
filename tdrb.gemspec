require_relative "lib/tdrb/version"

Gem::Specification.new do |s|
  s.name        = "tdrb"
  s.version     = TDRB::VERSION

  s.summary     = "Ruby + Traindown = TDRB"
  s.description = "A fun little gem chockful of Traindown tchotchkies"

  s.authors     = ["Tyler Scott"]
  s.email       = "tyler@greaterscott.com"

  s.files       = Dir["lib/**/*.rb"]

  s.homepage    = "https://traindown.com"
  s.license     = "BSD-3-Clause"

  s.metadata["homepage_uri"]    = s.homepage
  s.metadata["source_code_uri"] = s.homepage
  s.metadata["changelog_uri"]   = s.homepage

  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0")
end
