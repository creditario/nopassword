# frozen_string_literal: true

$LOAD_PATH << File.expand_path("lib", __dir__)
require_relative "lib/no_password/version"

Gem::Specification.new do |spec|
  spec.name = "no_password_auth"
  spec.version = NoPassword::VERSION
  spec.authors = ["Mario Alberto Chávez", "Armando Escalier", "Juan Bojorges"]
  spec.homepage = "https://aoorora.com"
  spec.summary = "Passwordless Ruby on Rails engine."
  spec.description = "NoPassword is a Ruby on Rails gem that allows session authentication with a token or a magic link via an email sent to the user; there is no need for a password."
  spec.license = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/creditario/nopassword"
  spec.metadata["changelog_uri"] = "https://github.com/creditario/nopassword"

  spec.files = Dir["{app,config,db,lib,docs}/**/*", "MIT-LICENSE", "Rakefile", "README.md", "README-ES.md"]

  spec.add_dependency "rails", ">= 7.1.0", "<= 8.1.0"
  spec.add_dependency "turbo-rails"
  spec.add_dependency "stimulus-rails"
  spec.add_dependency "importmap-rails"
  spec.add_dependency "tailwindcss-rails"
  spec.add_development_dependency "standard"
  spec.add_development_dependency "brakeman"
  spec.add_development_dependency "bundle-audit"
end
