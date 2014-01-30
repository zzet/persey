require "persey/version"
require "persey/builder"
require "persey/inspector"
require "persey/loader"
require "persey/adapters/base"
require "persey/adapters/yaml"
require "persey/adapters/json"
require "persey/adapters/toml"
require "persey/adapters/ini"
require "persey/configus_patch"

module Persey
  class << self
    def init(environment, &block)
      e = environment.is_a?(Symbol) ? environment : environment.to_sym
      configs  = Inspector.analize(&block)
      defaults = Loader.load(configs, e)
      @config  = Builder.build(e, defaults, &block)
    end

    def config
      raise RuntimeError, "Please, init config before usage" if @config.nil?

      @config
    end
  end
end
