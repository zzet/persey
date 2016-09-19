require 'active_support/inflector'

module Persey
  class Inspector
    class << self
      def analize(&block)
        @sources = []
        instance_eval(&block)
        @sources
      end

      def source(source_type, config_file, namespace = nil)
        begin
          klass = "persey/adapters/#{source_type}".camelize.constantize
          @sources << { class: klass, file: config_file, namespace: namespace } if File.exist?(config_file)
        rescue
          binding.pry
        end
      end

      def env(*args)
        # Nithing. I do not want call method_missing
      end
    end
  end
end
