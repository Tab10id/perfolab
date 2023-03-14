# frozen_string_literal: true

module PerfoLab
  module Runners
    # Base class for running performance tools
    class Base
      def initialize(report_dir)
        @report_dir = report_dir
      end

      def run(**options, &block)
        raise NotImplementedError
      end
    end
  end
end
