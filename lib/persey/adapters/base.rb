# frozen_string_literal: true

module Persey
  module Adapters
    class Base
      class << self
        def load(file, env, opts)
          raise NotImplementedError
        end

        def symbolize_keys(hash)
          hash.each_with_object({}) do |(k, v), res|
            n_k = k.is_a?(String) ? k.to_sym : k
            n_v = v.is_a?(Hash) ? symbolize_keys(v) : v
            res[n_k] = n_v
            res
          end
        end

        def config_exists?(path, _opts)
          File.exist?(path)
        end
      end
    end
  end
end
