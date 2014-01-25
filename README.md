# Persey [![Build Status](https://travis-ci.org/zzet/persey.png?branch=master)](https://travis-ci.org/zzet/persey)

## Summary

Persey help you easily manage the configuration, depending on the environment. 
The main objective is to provide opportunities to reuse the
configuration provided by the project, as the default configuration.

## Installing

Add this to your `Gemfile`:

    gem "persey"

## Examples

### Definition

``` ruby
redis_config = File.join(Rails.root, 'config', redis.yml.example)
project_config = File.join(Rails.root, 'config', project.yml.example)
awesome_gem_config = File.join(Rails.root, 'config', awesome_gem_config.yml)
my_secret_key_config = '/home/user/secret/keys.yml'

Persey.init :development do # set current environment
  sourse :yaml,   redis_config,   :redis   # set specific namespace for settings
  project :yaml,  project_config
  project :yaml,  awesome_gem_config
  project :yaml,  my_secret_key_config

  env :production do
    site_name 'Example'
    web do
      domain   'example.com'
      protocol 'https'
      port     80
      uri      -> { "#{protocol}://#{domain}:#{port}" }
    end
    site_uri   -> { web.uri }
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

### Usage

    config = Persey.config

    config.site_name      # => 'Example'
    config.web.uri        # => 'https://example.com:80'
    config.site_uri       # => 'https://example.com:80'
    config.email.pop.port # => 110

### Rails

define your config in `lib/config.rb`

    Persey.init Rails.env do
      # settings
    end

reload

    # config/environments/development.rb
    ActionDispatch::Reloader.to_prepare do
      load Rails.root.join('lib/config.rb')
    end

## Similar

* https://github.com/kaize/configus (this gem based on configus)
* https://github.com/markbates/configatron
* https://github.com/railsjedi/rails_config
