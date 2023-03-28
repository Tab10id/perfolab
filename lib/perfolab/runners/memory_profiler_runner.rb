# frozen_string_literal: true

require "memory_profiler"

module PerfoLab
  module Runners
    # :nodoc:
    class MemoryProfilerRunner < Base
      def run(n, &block)
        result = MemoryProfiler.report(**config) { block.call(n) }
        result.pretty_print(to_file: "#{@reports_dir}/memory_profiler.txt")
        props = %w[total_allocated_memsize total_allocated total_retained_memsize total_retained]
        props.map do |prop|
          value = result.__send__(prop)
          Metric.new(property: prop, value: value, value_formatted: value)
        end
      end
    end
  end
end
