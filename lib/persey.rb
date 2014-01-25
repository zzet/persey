require "persey/version"
require "persey/builder"
require "persey/inspector"
require "persey/loader"
require "persey/adapters/yaml"

module Persey
  class << self
    def init(environment, &block)
      configs  = Inspector.analize(&block)
      defaults = Loader.load(configs, environment)
      @config  = Builder.build(environment, defaults, &block)
    end

    def config
      raise RuntimeError, "Please, init config before usage" if @config.nil?

      @config
    end
  end
end
