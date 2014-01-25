require 'test_helper'

class PerseyTest < TestCase
  def setup
    plain_config = File.join(fixtures_path, 'yaml_config.yml')
    env_config = File.join(fixtures_path, 'yaml_config_with_envs.yml')

    Persey.init :production do
      source :yaml, plain_config
      source :yaml, env_config, :namespace

      env :production do
        option do
          first "first value"
          second "second value"
        end
      end
    end
  end

  def test_load_config
    assert { Persey.config }
  end

  def test_correct_config
    @config = Persey.config
    assert { @config.option.first == "first value" }
    assert { @config.namespace.another_key == "another key value" }
    assert { @config.key == "key value" }
  end
end
