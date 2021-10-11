require 'json'
require 'aws-sdk-ssm'

module Persey
  class MissingEnvVariable < RuntimeError; end

  module Adapters
    class Ssm < Persey::Adapters::Base
      class << self
        def load(path, env)
          ssm = Aws::SSM::Client.new()
          raw_hash = JSON.parse(ssm.get_parameter(name: path, with_decryption: true).parameter.value)
          symbolize_keys(raw_hash)
        end
      end
    end
  end
end
