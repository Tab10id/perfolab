# frozen_string_literal: true

require "benchmark"

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
        new.tap do |toolbox|
          yield(toolbox) if block_given?
        end
      end
    end

    attr_reader :tools

    def initialize
      @tools =
        Hash.new do |_h, name|
          raise ArgumentError, "tool with name #{name} already exist"
        end
    end

    def add_tool(name, type:, config: {}, runner_options: {})
      @tools[name] =
        PROFILERS[type].new(
          config: default_config[type].merge(config),
          runner_options: default_runner_options.merge(runner_options)
        )
    end

    def analyze(reports_dir:, &block)
      run_profilers(reports_dir: reports_dir, &block)
    end

    private

    def run_profilers(reports_dir:, &block)
      tools.each_with_object({}) do |(name, tool), results|
        results[name.to_s] = tool.perform(reports_dir: reports_dir, &block)
      end
    end

    def default_config # rubocop:disable Metrics/MethodLength
      {
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
        benchmark: {}
      }
    end

    def default_runner_options
      {
        gc_disable: true,
        warmup: 0
      }
    end
  end
end
