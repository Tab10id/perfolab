# frozen_string_literal: true

require_relative "lib/perfolab/version"

Gem::Specification.new do |spec|
  spec.name = "perfolab"
  spec.version = PerfoLab::VERSION
  spec.authors = ["Dmitry Lisichkin"]
  spec.email = ["tabloidmeister@gmail.com"]

  spec.summary = "Continuous performance analyzer"
  spec.description =
    <<~DESCRIPTION
      A tool for simplifying collect and diff performance metrics during development
    DESCRIPTION
  spec.homepage = "https://github.com/Tab10id/perfolab"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] =
    "https://github.com/Tab10id/perfolab"
  spec.metadata["changelog_uri"] =
    "https://github.com/Tab10id/perfolab/blob/master/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "benchmark-trend", "~> 0.4.0"
  spec.add_dependency "memory_profiler", "~> 1.0"
  spec.add_dependency "ruby-prof", "~> 1.6"
  spec.add_dependency "stackprof", "~> 0.2.0"

  spec.add_dependency "tabulo", "~> 2.0"
  spec.add_dependency "zeitwerk", "~> 2.6"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
