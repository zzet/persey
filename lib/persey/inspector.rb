require 'active_support/inflector'

module Persey
  class MissingConfigFile < RuntimeError; end

  class Inspector
    class << self
      def analize(&block)
        @sources = []
        instance_eval(&block)
        @sources
      end

      def source(source_type, config_file, namespace = nil)
        raise MissingConfigFile.new("Can't find #{source_type} config: #{config_file}") unless File.exist?(config_file)

        klass = "persey/adapters/#{source_type}".camelize.constantize
        @sources << { class: klass, file: config_file, namespace: namespace }

        override_config_file = config_file + '.override'
        @sources << { class: klass, file: override_config_file, namespace: namespace } if File.exist?(override_config_file)
      end

      def env(*args)
        # Nithing. I do not want call method_missing
      end
    end
  end
end
