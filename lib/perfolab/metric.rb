# frozen_string_literal: true

module PerfoLab
  Metric = Struct.new(:argument, :property, :value, :value_formatted, keyword_init: true)
end
