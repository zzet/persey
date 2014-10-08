require 'test_helper'

class PerseyTest < TestCase
  def setup
    plain_config = File.join(fixtures_path, 'yaml_config.yml')
    env_config = File.join(fixtures_path, 'yaml_config_with_envs.yml')
    plain_json_config = File.join(fixtures_path, 'json_config.json')
    plain_toml_config = File.join(fixtures_path, 'toml_config.toml')
    plain_ini_config = File.join(fixtures_path, 'ini_config.ini')

    Persey.init :production do
      source :yaml, plain_config
      source :yaml, env_config,         :namespace
      source :json, plain_json_config,  :json_config
      source :toml, plain_toml_config,  :toml_config
      source :ini,  plain_ini_config,   :ini_config

      env :production do
        option do
          first "first value"
          second "second value"
        end

        first do
          testss -> { second }
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
    assert { @config.first.testss == "foo value" }
    assert { @config.first.second == "foo value" }
    assert { @config.namespace.another_key == "another key value" }
    assert { @config.namespace.another_key == "another key value" }
    assert { @config.key == "key value" }
    assert { @config.json_config.owner.name == "John Doe" }
    assert { @config.toml_config.owner.name == "Tom Preston-Werner" }
    assert { @config.ini_config.section1.var1 == "foo" }
  end
end
