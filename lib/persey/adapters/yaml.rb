require 'yaml'

module Persey
  module Adapters
    class Yaml
      class << self
        def load(file, env)
          begin
            raw_hash = YAML.load_file(file)
            symbolize_keys(raw_hash)
          rescue
            binding.pry
          end
        end

        private

        def symbolize_keys(hash)
          hash.inject({}){|res, (k, v)|
            n_k = k.is_a?(String) ? k.to_sym : k
            n_v = v.is_a?(Hash) ? symbolize_keys(v) : v
            res[n_k] = n_v
            res
          }
        end
      end
    end
  end
end
