module Persey
  module Adapters
    class Json

      class << self
        def load(file, env)
          begin
            raw_hash = YAML.load_file(file)
            symbolize_keys(raw_hash)
          rescue
            binding.pry
          end
        end
      end

    end
  end
end
