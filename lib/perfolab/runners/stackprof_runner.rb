# frozen_string_literal: true

require "stackprof"

module PerfoLab
  module Runners
    # :nodoc:
    class StackprofRunner < Base
      def run(n, &block)
        result = StackProf.run(**config) { block.call(n) }
        reporter = StackProf::Report.new(result)

        report_dump(result)
        report_text(reporter)
        report_flamegraph(reporter)
        []
      end

      private

      def report_dump(result)
        File.open("#{@reports_dir}/stackprof-cpu.dump", "wb") do |f|
          f.write(Marshal.dump(result))
        end
      end

      def report_text(reporter)
        File.open("#{@reports_dir}/stackprof-cpu.txt", "w") do |file|
          reporter.print_text(false, nil, nil, nil, nil, nil, file)
        end
      end

      def report_flamegraph(reporter)
        File.open("#{@reports_dir}/stackprof.d3-flamegraph.html", "w") do |f|
          reporter.print_d3_flamegraph(f)
        end
      end
    end
  end
end
