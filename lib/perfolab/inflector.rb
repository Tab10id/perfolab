# frozen_string_literal: true
#
module PerfoLab
  class Inflector < Zeitwerk::GemInflector
    def camelize(basename, abspath)
      basename == "perfolab" ? "PerfoLab" : super
    end
  end
end
