# frozen_string_literal: true

require_relative "lib/easy_weibo/version"

Gem::Specification.new do |spec|
  spec.name          = "easy_weibo"
  spec.version       = EasyWeibo::VERSION
  spec.authors       = ["42up"]
  spec.email         = ["foobar@v2up.com"]

  spec.summary       = "An unofficial easy weibo sdk"
  spec.description   = "An unofficial easy weibo sdk"
  spec.homepage      = "https://github.com/42up/easy_weibo"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'https://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "httpx"
  spec.add_dependency "activesupport"
  spec.add_dependency "http-form_data"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
