module Persey
  module Adapters
    class Base
      class << self
        def load(file, env)
          raise NotImplementedError
        end

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
