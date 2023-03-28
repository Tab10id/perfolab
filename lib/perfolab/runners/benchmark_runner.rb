# frozen_string_literal: true

module PerfoLab
  module Runners
    class BenchmarkRunner < Base
      def run(n, &block)
        GC.start

        benchmark_tms = Benchmark.measure { block.call(n) }
        %w[utime stime cutime cstime real total].map do |prop|
          value = benchmark_tms.__send__(prop)
          Metric.new(property: prop, value: value, value_formatted: "#{(value * 1000).to_i}ms")
        end
      end
    end
  end
end
