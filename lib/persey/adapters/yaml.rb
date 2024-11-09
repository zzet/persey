require 'yaml'
require 'erb'

module Persey
  class MissingEnvVariable < RuntimeError; end

  module Adapters
    class Yaml < Persey::Adapters::Base
      class << self
        def load(file, env)
          begin
            yaml_content = ERB.new(File.read(file)).result

            raw_hash = if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new('3.1')
              ::Psych.load(yaml_content, aliases: true, symbolize_names: true)
            else
              ::YAML.load(yaml_content)
            end

            symbolize_keys(raw_hash)
          rescue KeyError => e
            _, line, method = /\(erb\):(\d+):in `(.*)'/.match(e.backtrace[0]).to_a
            if method == 'fetch'
              raise MissingEnvVariable.new("Check line ##{line} in #{file}")
            else
              raise e
            end
          end
        end
      end

      private

      def self.symbolize_keys(hash)
        return hash unless hash.is_a?(Hash)

        hash.each_with_object({}) do |(key, value), result|
          new_key = key.respond_to?(:to_sym) ? key.to_sym : key
          new_value = value.is_a?(Hash) ? symbolize_keys(value) : value
          result[new_key] = new_value
        end
      end
    end
  end
end
