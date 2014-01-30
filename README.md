# Persey [![Build Status](https://travis-ci.org/zzet/persey.png?branch=master)](https://travis-ci.org/zzet/persey) [![Gem Version](https://badge.fury.io/rb/persey.png)](http://badge.fury.io/rb/persey) [![Dependency Status](https://gemnasium.com/zzet/persey.png)](https://gemnasium.com/zzet/persey) [![Code Climate](https://codeclimate.com/github/zzet/persey.png)](https://codeclimate.com/github/zzet/persey) [![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/zzet/persey/trend.png)](https://bitdeli.com/free "Bitdeli Badge")


## Summary

Persey help you easily manage the configuration, depending on the environment. 
The main objective is to provide opportunities to reuse the
configuration provided by the project, as the default configuration.

## Problem

For the occurrence of the gem was a few prerequisites.

 * Work on opensource projects that support the relevance of problem configurations, changing the appearance of new versions and functionality. 
 * Use in the project configuration, diversity in different files, and the inability to unite all in one configuration 
 * Desire to use sensitive data as easily as those that can be safely stored in the repository.
 * Sometimes configuration happens in a variety of formats: yaml, json, ini 

I do not want to engage in writing parsers, I want to work fine :) 

This solution allows to **accumulate** different configs in one, with the **possibility of reusability** of configuration options and **simple override**. It uses an **intuitive DSL**.

## Installing

Add this to your `Gemfile`:

``` ruby
gem "persey", '>= 0.0.7'
```

Generate default config file

``` bash
$ rails g persey:install
```

## Examples

### Definition

``` ruby
# Rails.root are not initialized here
app_path = File.expand_path('../../', __FILE__)

# your redis config
redis_config = File.join(app_path, 'config', 'redis.yml.example')

# your project config
# as example - it's default options from opensource
# you don't want redeclare then with copy default file
project_config = File.join(app_path, 'config', 'project.yml.example')

# some different environment specifed configuration options in separate config
project_env_config = File.join(app_path, 'config', "project.#{Rails.env}.yml")

# config for awesome gem
awesome_gem_config = File.join(app_path, 'config', 'awesome_gem_config.yml')

# config with secret keys
# you don't want store this config in repository and copy to secret folder on host machine
my_secret_key_config = '/home/user/secret/keys.yml'

# We support not only YAML
# Also JSON
my_node_js_config = '/rest/u/apps/node/config.json'
# And TOML
my_berkshelf_config = File.join(app_path, 'provisioning', '.berkshelf')
# And INI
my_ini_config = File.join(app_path, 'provisioning', 'php.ini') # lol

# Persey.init ENV["environment"] do # set current environment
Persey.init Rails.env do # set current environment
  sourse :yaml, redis_config,         :redis              # set specific namespace for settings (mount config in :redis key)
  source :yaml, project_config                            # if project config and project_env_config have some options keys
  source :yaml, project_env_config                        # last declared keys overwite before declared
  source :yaml, awesome_gem_config,   :awesome_gem        # it's good to mount unknown configs to special :namespace
  source :yaml, my_secret_key_config, :secret             # no comments. It's secret!
  source :json, my_node_js_config,    :node_js_namespace
  source :toml, my_berkshelf_config,  :berkshelf_namespace
  source :ini,  my_ini_config,        :ini_namespace

  env :production do
    site_name 'Example'
    web do
      # domain   'example.com'   # domain described in project_env_config
                                 # you can use them, or overwirite here
      protocol 'https'           # we overwrite prolocol option here
                                 # by default was 'http', but we need some little security
      port      12345            # more, more security!
      # and now we use configs for our options, which are not declared in any config
      uri      -> { "#{protocol}://#{domain}:#{port}" }
    end
    
    site_uri   -> { web.uri }    # we can re-re-use different options
    
    email do
      pop do
        address 'pop.example.com'
        port    110
      end
      smtp do
        address 'smtp.example.com'
        port    25
      end
    end
  end

  env :development, :parent => :production do
    web do
      domain   'localhost'
      protocol 'http'
      port      9292
    end
    email do
      smtp do
        address 'smpt.text.example.com'
      end
    end
  end
end
```
If you generate Persey config with run `rails g persey:install` in your `config/application.rb` were added strings to run config initialization. If you do not run installer, you can specify of run config manually. For example:

in your `config/application.rb`

``` ruby
#...
# We require gem here
require "persey"
require File.expand_path('../config', __FILE__)

module AppName
  # If you don't want use configs with call Persey.config
  # you can do something like it:
  def self.config
    Persey.config
  end
  
  class Application < Rails::Application
    # ...
  end
end

```

### Usage

``` ruby
config = Persey.config

config.site_name      # => 'Example'
config.web.uri        # => 'https://example.com:80'
config.site_uri       # => 'https://example.com:80'
config.email.pop.port # => 110

AppName.config.site_name # => 'Example'
```

### Rails

define your config in `config/config.rb`

``` ruby
Persey.init Rails.env do
  # settings
end
```

reload

``` ruby
# config/environments/development.rb
ActionDispatch::Reloader.to_prepare do
  load Rails.root.join('config/config.rb')
end
```

## Supported config formats

* YAML
* JSON
* TOML
* INI

## Similar

* https://github.com/kaize/configus (this gem based on configus)
* https://github.com/markbates/configatron
* https://github.com/railsjedi/rails_config

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## Another help

You can give me feedback with issue.
