# frozen_string_literal: true

module PerfoLab
  module Runners
    class BenchmarkRunner < Base
      def run(start:, limit:, ratio:, &block)
        range = Benchmark::Trend.range(start, limit, ratio: ratio)

        # warmup
        range.each(&block)

        results =
          range.map do |n|
            GC.start
            total = (Benchmark.measure { yield(n) }.total * 1000).to_i
            [n.to_s, "#{total}ms"]
          end
        results.to_h
      end
    end
  end
end
