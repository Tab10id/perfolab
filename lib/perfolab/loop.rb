# frozen_string_literal: true

require "tempfile"
require "yaml"

module PerfoLab
  # Осуществляет запуск профилировщиков и бенчмарков в цикле с предоставлением обратной связи и
  # упрощением выполнения рутинных операций
  class Loop
    attr_reader :toolbox, :reports_root, :results_file_name, :study_file_name, :new_results

    def initialize(reports_root: "reports", &block)
      @toolbox = PerfoLab::Toolbox.configure(&block)
      @reports_root = reports_root
      @results_file_name = "#{reports_root}/last_analyze_results.yaml"
      @study_file_name = "#{reports_root}/study.md"
    end

    def analyze(&block)
      puts "Enter experiment name (or leave empty):"
      user_report_name = gets.chomp
      report_time = Time.new.strftime("%y-%m-%d_%H-%M-%S")
      report_name = user_report_name.empty? ? report_time : "#{report_time}_#{user_report_name}"
      reports_dir = "#{reports_root}/#{report_name}"
      FileUtils.mkdir_p(reports_dir)

      @new_results = toolbox.analyze(reports_dir: reports_dir, &block)
      check_results
    end

    private

    def check_results
      puts diff_results
      return unless we_happy?

      save_results
      show_editor
    end

    def diff_results
      tools = old_results.keys | new_results.keys
      diff = +""
      tools.each do |tool|
        tool_old_results = old_results[tool] || []
        tool_new_results = new_results[tool] || []
        diff << DiffGenerator.new(tool_old_results, tool_new_results).render_diff_table(tool)
        diff << "\n\n"
      end
      diff
    end

    def old_results
      @old_results ||=
        if File.exist?(results_file_name)
          YAML.safe_load(
            File.read(results_file_name),
            permitted_classes: [Symbol, PerfoLab::Metric]
          )
        else
          {}
        end
    end

    def we_happy?
      puts "Vincent, we happy? [(y)eah! we happy / (N)ay]"
      gets.chomp == "y"
    end

    def show_editor
      report = edit_tempfile

      if empty_report?(report)
        puts "Report not saved"
        return
      end

      append_stages(report)
    end

    def save_results
      File.write(results_file_name, new_results.to_yaml)
    end

    def edit_tempfile
      tempfile = Tempfile.open("perf_analyze_stage")
      tempfile.write("\n\n")
      tempfile.write(diff_results.split("\n").map { |l| "// #{l}" }.join("\n"))
      tempfile.close

      system("#{ENV.fetch("EDITOR", "vim")} #{tempfile.path}")
      report = read_report(tempfile)
    ensure
      tempfile.unlink
      report
    end

    def read_report(tempfile)
      File.read(tempfile.path)
          .split("\n")
          .reject { |l| l.start_with?("//") }
          .join("\n")
    end

    def empty_report?(report)
      report.chomp.empty?
    end

    def append_stages(report)
      File.open(study_file_name, "a") do |f|
        f.write("\n")
        f.write(report)
        f.write("\n")
        f.write(diff_results)
      end
    end
  end
end
