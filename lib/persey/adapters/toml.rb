# frozen_string_literal: true

require 'toml'

module Persey
  module Adapters
    class Toml < Persey::Adapters::Base
      class << self
        def load(file, _env, opts: {})
          raw_hash = TOML.load_file(file)
          symbolize_keys(raw_hash)
        rescue
          puts "FATAL: Error while process config from file '#{file}'"
        end
      end
    end
  end
end
