# frozen_string_literal: true

require 'yaml'
require 'erb'

module Persey
  class MissingEnvVariable < RuntimeError; end

  module Adapters
    class Yaml < Persey::Adapters::Base
      class << self
        def load(file, _env, opts: {})
          raw_hash = YAML.load(ERB.new(File.read(file)).result)
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
  end
end
