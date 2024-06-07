# frozen_string_literal: true

require_relative "lib/rubydium/version"

Gem::Specification.new do |spec|
  spec.name          = "rubydium"
  spec.version       = Rubydium::VERSION
  spec.authors       = ["bulgakke"]
  spec.email         = ["be.evgeniy.bulavin@gmail.com"]

  spec.summary       = "An OO framework for building Telegram bots. That's the plan, at least."
  # spec.description   = "TODO: Write a longer description or delete this line."
  spec.homepage      = "https://github.com/bulgakke/rubydium"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 3.1.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/bulgakke/rubydium"
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"

  {
    "telegram-bot-ruby" => ["~> 1.0.0"],
    "async" => ["~> 2.3"]
  }.each do |name, versions|
    spec.add_dependency(name, *versions)
  end
end
