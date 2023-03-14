# frozen_string_literal: true

require "benchmark"
require "benchmark-trend"

module PerfoLab
  # Run configured tools for performance analyze
  class Toolbox
    PROFILERS = {
      memory_profiler: Runners::MemoryProfilerRunner,
      ruby_prof: Runners::RubyProfRunner,
      stackprof: Runners::StackprofRunner,
      benchmark: Runners::BenchmarkRunner
    }.freeze

    class << self
      def configure
        new.tap do |stand|
          yield(stand.config) if block_given?
        end
      end
    end

    attr_reader :config

    def initialize
      @config = default_config
    end

    def analyze(reports_dir:, &block)
      GC.disable if config[:gc_disable]

      run_profilers(reports_dir: reports_dir, &block)
    ensure
      GC.enable
    end

    private

    def run_profilers(reports_dir:, &block)
      PROFILERS.each_with_object({}) do |(type, klass), results|
        results[type.to_s] = klass.new(reports_dir).run(**config[type], &block)
      end
    end

    def default_config # rubocop:disable Metrics/MethodLength
      {
        gc_disable: true,
        memory_profiler: {
          # top: 50, # maximum number of entries to display in a report (default is 50)
          # allow_files: //, # include only certain files from tracing - can be given as a String, Regexp, or array of Strings
          # ignore_files: //, # exclude certain files from tracing - can be given as a String or Regexp
          # trace: [], # an array of classes for which you explicitly want to trace object allocations
        },
        ruby_prof: {
          track_allocations: true
        },
        stackprof: {
          mode: :wall,
          raw: true
        },
        benchmark: {
          ratio: 8
        }
      }
    end
  end
end
