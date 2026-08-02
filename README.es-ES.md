# Persey [![Estado de la compilación](https://travis-ci.org/zzet/persey.svg?branch=master)](https://travis-ci.org/zzet/persey) [![Versión de Gem](https://badge.fury.io/rb/persey.svg)](http://badge.fury.io/rb/persey) [![Code Climate](https://codeclimate.com/github/zzet/persey.svg)](https://codeclimate.com/github/zzet/persey) [![Número de descargas](https://img.shields.io/gem/dt/persey.svg)](https://img.shields.io/gem/dt/persey.svg)


## Resumen

Persey te ayuda a gestionar fácilmente la configuración dependiendo del entorno en el que te encuentres.
Su principal objetivo es ofrecerte la posibilidad de reutilizar la configuración proporcionada por el proyecto, como la configuración predeterminada.

## El problema

La creación de este gem surgió de varias necesidades:

* Trabajar en proyectos de código abierto que reconocen la importancia de la gestión de configuraciones, ya que estas cambian con las nuevas versiones y funcionalidades.
* Utilizar la configuración en un proyecto, distribuida en diferentes archivos, y la imposibilidad de unificar todo en una sola configuración.
* Desear utilizar datos sensibles con la misma facilidad que aquellos que pueden almacenarse de forma segura en el repositorio.
* En ocasiones, la configuración se realiza en diversos formatos: yaml, json, ini.

No quiero dedicar tiempo a escribir analizadores; ¡quiero trabajar de forma eficiente!

Esta solución permite **combinar** diferentes configuraciones en una sola, con la **posibilidad de reutilizar** opciones de configuración y una **sobrescritura sencilla**. Utiliza un **lenguaje DSL intuitivo**.

## Instalación

Añade lo siguiente a tu `Gemfile`:

```ruby
gem "persey", '>= 1.0.0'
```

Genera el archivo de configuración predeterminado:

```bash
$ rails g persey:install
```

## Ejemplos

### Definición

```ruby
# Rails.root no está inicializado aquí
app_path = File.expand_path('../../', __FILE__)

# Configuración de Redis
redis_config = File.join(app_path, 'config', 'redis.yml.example')

# Configuración del proyecto
# Como ejemplo, son las opciones predeterminadas de un proyecto de código abierto.
# No es necesario volver a declararlas con una copia del archivo predeterminado.
project_config = File.join(app_path, 'config', 'project.yml.example')

# Opciones de configuración específicas del entorno en un archivo separado
project_env_config = File.join(app_path, 'config', "project.#{Rails.env}.yml")

# Configuración para el gem awesome
awesome_gem_config = File.join(app_path, 'config', 'awesome_gem_config.yml')

# Configuración con claves secretas
# No deseas almacenar esta configuración en el repositorio y copiarla en la carpeta secreta de la máquina host.
my_secret_key_config = '/home/user/secret/keys.yml'

# No solo apoyamos YAML
# También JSON
my_node_js_config = '/rest/u/apps/node/config.json'
# Y TOML
my_berkshelf_config = File.join(app_path, 'provisioning', '.berkshelf')
# Y INI
my_ini_config = File.join(app_path, 'provisioning', 'php.ini') # lol

# Persey.init ENV["environment"] do # Establecer entorno actual
Persey.init Rails.env do # Establecer entorno actual
  source :yaml, redis_config,         :redis              # Establecer un espacio de nombres específico para la configuración (montar configuración en la clave :redis)
  source :yaml, project_config                            # Si project_config y project_env_config tienen algunas claves de opciones
  source :yaml, project_env_config                        # Las últimas claves declaradas sobrescriben las anteriores
  source :yaml, awesome_gem_config,   :awesome_gem        # Es recomendable montar configuraciones desconocidas en un espacio de nombres especial
  source :yaml, my_secret_key_config, :secret             # Sin comentarios. ¡Es secreto!
  source :json, my_node_js_config,    :node_js_namespace
  source :toml, my_berkshelf_config,  :berkshelf_namespace
  source :ini,  my_ini_config,        :ini_namespace

  env :production do
    site_name 'Example'
    web do
      # domain   'example.com'   # Dominio descrito en project_env_config
                                 # Puedes usarlos o sobrescribirlos aquí
      protocol 'https'           # Sobrescribimos la opción de protocolo aquí
                                 # Por defecto era 'http', pero necesitamos un poco de seguridad
      port      12345            # ¡Más seguridad!
      # Y ahora usamos configuraciones para nuestras opciones, que no están declaradas en ninguna configuración
      uri      -> { "#{protocol}://#{domain}:#{port}" }
    end

    site_uri   -> { web.uri }    # Podemos reutilizar diferentes opciones

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
Si generas la configuración de Persey ejecutando `rails g persey:install` en tu `config/application.rb`, se añadirán las líneas necesarias para inicializar la configuración. Si no ejecutas el instalador, puedes inicializar la configuración manualmente. Por ejemplo:

en tu `config/application.rb`:

```ruby
#...
# Requerimos el gem aquí
require "persey"
require File.expand_path('../config', __FILE__)

module AppName
  # Si no deseas utilizar la configuración con la llamada Persey.config,
  # puedes hacer algo como esto:
  def self.config
    Persey.config
  end

  class Application < Rails::Application
    # ...
  end
end
```

### Uso

```ruby
config = Persey.config

config.site_name      # => 'Example'
config.web.uri        # => 'https://example.com:80'
config.site_uri       # => 'https://example.com:80'
config.email.pop.port # => 110

AppName.config.site_name # => 'Example'
```

### Rails

Define tu configuración en `config/config.rb`:

```ruby
Persey.init Rails.env do
  # configuraciones
end
```

Recargar:

```ruby
# config/environments/development.rb
ActionDispatch::Reloader.to_prepare do
  load Rails.root.join('config/config.rb')
end
```

## Formatos de configuración compatibles

* YAML
* JSON
* TOML
* INI

## Similares

* https://github.com/kaize/configus (este gem se basa en configus)
* https://github.com/markbates/configatron
* https://github.com/railsjedi/rails_config

## Contribuir

1. Haz un fork.
2. Crea una nueva rama con tus cambios (`git checkout -b my-new-feature`).
3. Commit tus cambios (`git commit -am 'Added some feature'`).
4. Push a la rama (`git push origin my-new-feature`).
5. Crea un nuevo Pull Request.

## Más ayuda

Puedes darme feedback a través de un issue.
