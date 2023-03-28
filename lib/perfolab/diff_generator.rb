# frozen_string_literal: true

require "tabulo"

module PerfoLab
  # render diff table for collection of previous and current metrics
  class DiffGenerator
    MetricDiff =
      Struct.new(:property,
                 :argument,
                 :old_value,
                 :old_value_formatted,
                 :new_value,
                 :new_value_formatted,
                 keyword_init: true) do
        def diff_percent
          return if !new_value || !old_value || old_value.zero?

          "#{(((new_value - old_value) * 100) / old_value).to_i}%"
        end
      end

    def initialize(old_metrics, new_metrics, table_mode: :property)
      @old_metrics = old_metrics
      @new_metrics = new_metrics

      @rows, @columns = rows_columns_by_table_mode(table_mode)
    end

    def render_diff_table(tool)
      tabulo(
        normalize_metrics.group_by(&@rows).map do |row, metrics|
          [row,
           format_column(metrics, :old_value_formatted),
           format_column(metrics, :new_value_formatted),
           metrics.map(&:diff_percent).join("\n")]
        end,
        tool
      )
    end

    private

    def rows_columns_by_table_mode(table_mode)
      case table_mode
      when :property
        %i[property argument]
      when :argument
        %i[argument property]
      else
        raise ArgumentError, "Wrong table mode"
      end
    end

    def normalize_metrics
      grouped_old_results = grouped_results(@old_metrics)
      grouped_new_results = grouped_results(@new_metrics)

      all_rows.flat_map do |row|
        all_columns.map do |column|
          old_result = grouped_old_results[[row, column]]
          new_result = grouped_new_results[[row, column]]
          prepare_metric_diff(column, new_result, old_result, row)
        end
      end
    end

    def grouped_results(metrics)
      metrics.group_by { |r| [r[@rows], r[@columns]] }.transform_values(&:first)
    end

    def all_rows
      @old_metrics.map(&@rows) | @new_metrics.map(&@rows)
    end

    def all_columns
      @old_metrics.map(&@columns) | @new_metrics.map(&@columns)
    end

    def prepare_metric_diff(column, new_result, old_result, row)
      MetricDiff.new(
        @rows => row,
        @columns => column,
        old_value: old_result&.value,
        old_value_formatted: old_result&.value_formatted,
        new_value: new_result&.value,
        new_value_formatted: new_result&.value_formatted
      )
    end

    def format_column(metrics, value)
      metrics.map { |m| m[@columns] ? "#{m[@columns]}: #{m[value]}" : m[value] }.join("\n")
    end

    def tabulo(rows, tool)
      Tabulo::Table.new(rows, border: :markdown) do |t|
        t.add_column(tool.to_s, width: 30) { |row, _metrics| row[0] }
        t.add_column("Previous", width: 15) { |row| row[1] }
        t.add_column("Current", width: 15) { |row| row[2] }
        t.add_column("Diff %", width: 15) { |row| row[3] }
      end.to_s
    end
  end
end
