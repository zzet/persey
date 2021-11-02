# frozen_string_literal: true

require 'json'
require 'aws-sdk-ssm'

module Persey
  class MissingEnvVariable < RuntimeError; end

  module Adapters
    class Ssm < Persey::Adapters::Base
      class << self
        def load(path, _env, opts: {})
          ssm = ssm_client(opts)
          param = ssm.get_parameter(name: path, with_decryption: true).parameter

          res = begin
                  JSON.parse(param.value)
                rescue JSON::ParserError
                  param.to_h
                end

          symbolize_keys(res)
        end

        def config_exists?(path, opts: {})
          ssm = ssm_client(opts)
          ssm.get_parameter(name: path, with_decryption: true).parameter.nil? == false
        rescue Aws::SSM::Errors::ParameterNotFound
          false
        end

        private

        def ssm_client(opts)
          opts[:client] || Aws::SSM::Client.new
        end
      end
    end
  end
end
