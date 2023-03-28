# frozen_string_literal: true

module PerfoLab
  module Runners
    # Base class for running performance tools
    class Base
      attr_reader :config, :runner_options

      def initialize(config:, runner_options:)
        @config = config
        @runner_options = runner_options
      end

      def perform(reports_dir:, gc_disable: true, &block)
        @reports_dir = reports_dir
        GC.disable if gc_disable
        runner_options[:warmup].times { warmup(&block) }

        argument_collection.flat_map do |n|
          run(n, &block).tap { |results| results.each { |m| m.argument = n } }
        end
      ensure
        GC.enable
      end

      def run(n, &block)
        raise NotImplementedError
      end

      private

      def warmup(&block)
        argument_collection.each(&block)
      end

      def argument_collection
        runner_options[:arguments] || [nil]
      end
    end
  end
end
