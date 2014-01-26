require 'configus'

module Persey
  class Builder
    class << self
      def build(environment, defaults, &block)
        b = new(environment, defaults, block)
        Configus::Config.new(b.result)
      end
    end

    def initialize(environment, defaults, block)
      @current_env = environment
      @config = defaults
      @envs = {}
      instance_eval(&block)
    end

    def result(env = nil)
      e = env || @current_env
      edata = @envs[e]

      raise ArgumentError, "Undefined environment '#{ env }" if edata.nil?

      current_config = {}
      if edata[:block]
        current_config = expand(edata[:block])
      end

      parent = edata[:options][:parent]
      if parent
        parent_config = result(parent)
        current_config = deep_merge(parent_config, current_config)
      end

      current_config = @config.merge(current_config)
    end

    private

    def env(env, options = {}, &block)
      env = env.to_sym

      raise ArgumentError, "Double definition of environment '#{ env }'" if @envs.has_key?(env)

      @envs[env] = { options: options }
      @envs[env][:block] = block if block_given?
    end

    def deep_merge(target, source)
      source.each_pair do |k,v|
        tv = target[k]
        target[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? deep_merge(tv, v) : v
      end
      target
    end

    def source(*args)
      # Nothing. It's Inspector method
    end

    def expand(block)
      Configus::Proxy.generate(block)
    end
  end
end
