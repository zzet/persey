module Persey
  class Loader
    attr_accessor :configs

    class << self
      def load(configs, env)
        l = new(configs)
        l.load(env)
      end
    end

    def initialize(configs)
      @configs = configs
    end

    def load(env)
      @defaults = {}

      configs.each do |pdc|
        klass = pdc[:class]
        raw_config = klass.load(pdc[:file], env)
        env_config = raw_config[env].nil? ? raw_config : raw_config[env]

        n = pdc[:namespace]
        if n.nil?
          @defaults.merge!(env_config)
        else
          @defaults[n].is_a?(Hash) ? @defaults[n].merge!(env_config) : @defaults[n] = env_config
        end
      end

      @defaults
    end
  end
end
