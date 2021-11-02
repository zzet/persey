# frozen_string_literal: true

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

      def source(source_type, config_file, namespace = nil, opts = {})
        klass = "persey/adapters/#{source_type}".camelize.constantize

        unless klass.config_exists?(config_file, opts: opts)
          raise MissingConfigFile, "Can't find #{source_type} config: #{config_file}"
        end

        @sources << { class: klass, file: config_file, namespace: namespace, opts: opts }

        override_config_file = config_file + '.override'
        @sources << { class: klass, file: override_config_file, namespace: namespace, opts: opts } if klass.config_exists?(override_config_file, opts: opts)
      end

      def env(*args)
        # Nithing. I do not want call method_missing
      end
    end
  end
end
