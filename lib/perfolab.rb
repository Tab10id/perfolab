# frozen_string_literal: true

require "zeitwerk"
require_relative "perfolab/inflector"

loader = Zeitwerk::Loader.for_gem
loader.inflector = PerfoLab::Inflector.new(__FILE__)
loader.setup

require_relative "perfolab/version"

module PerfoLab
end
