require 'inifile'

module Persey
  module Adapters
    class Ini < Persey::Adapters::Base
      class << self
        def load(file, env)
          begin
            raw_hash = IniFile.load(file).to_h
            symbolize_keys(raw_hash)
          rescue
            puts "FATAL: Error while process config from file '#{file}'"
          end
        end
      end
    end
  end
end
