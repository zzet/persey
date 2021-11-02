# frozen_string_literal: true

require 'json/stream'

module Persey
  module Adapters
    class Json < Persey::Adapters::Base
      class << self
        def load(file, _env, opts: {})
          json = File.new(file, 'r')
          raw_hash = JSON::Stream::Parser.parse(json)
          symbolize_keys(raw_hash)
        rescue
          puts "FATAL: Error while process config from file '#{file}'"
        end
      end
    end
  end
end
