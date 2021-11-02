# frozen_string_literal: true

require 'spec_helper'

describe Persey do
  context 'true-flow input data' do
    before do
      plain_config = File.join(fixtures_path, 'yaml_config.yml')
      env_config = File.join(fixtures_path, 'yaml_config_with_envs.yml')
      plain_json_config = File.join(fixtures_path, 'json_config.json')
      plain_toml_config = File.join(fixtures_path, 'toml_config.toml')
      plain_ini_config = File.join(fixtures_path, 'ini_config.ini')
      plain_ssm_config = '/some/ssm/parameter/path.json'

      Persey.init :production do
        source :yaml, plain_config
        source :yaml, env_config,         :namespace
        source :json, plain_json_config,  :json_config
        source :toml, plain_toml_config,  :toml_config
        source :ini,  plain_ini_config,   :ini_config
        source :ssm,  plain_ssm_config,   :ssm_config, { client: Aws::SSM::Client.new(stub_responses: true) }

        env :production do
          option do
            first 'first value'
            second 'second value'
          end

          first do
            testss -> { second }
          end
        end
      end
    end

    it '#config' do
      expect { Persey.config }.not_to raise_exception
    end

    it '#config.methods' do
      @config = Persey.config
      expect(@config.option.first).to eq('first value')
      expect(@config.first.testss).to eq('foo value')
      expect(@config.first.second).to eq('foo value')
      expect(@config.namespace.another_key).to eq('another key value')
      expect(@config.namespace.another_key).to eq('another key value')
      expect(@config.key).to eq('key value')
      expect(@config.json_config.owner.name).to eq('John Doe')
      expect(@config.toml_config.owner.name).to eq('Tom Preston-Werner')
      expect(@config.ini_config.section1.var1).to eq('foo')
      expect(@config.ssm_config.value).to eq('PSParameterValue')
    end
  end

  context 'false-flow data' do
    it 'missing config' do
      missing_config = File.join(fixtures_path, 'missing_yaml_config.yml')

      expect do
        Persey.init :production do
          source :yaml, missing_config

          env :production
        end
      end.to raise_error(Persey::MissingConfigFile)
    end

    it 'missing ENV.fetch' do
      broken_yaml_config = File.join(fixtures_path, 'broken_yaml_config.yml')

      expect do
        Persey.init :production do
          source :yaml, broken_yaml_config

          env :production
        end
      end.to raise_error(Persey::MissingEnvVariable)
    end
  end
end
