# NoPassword

NoPassword permite realizar autenticación de sesiones con un token o un link mágico enviado a tu email, sin necesidad de contraseñas.

## Tabla de contenido

- [Requerimientos previos](#requerimientos-previos)
- [Instalación](#instalación)
- [Configuración](#configuración)
    - [Configurar idiomas](#configurar-idiomas)
    - [Configuración para emails](#configuración-para-emails)
      - [Uso de letter opener](#uso-de-letter-opener)
    - [Personalización de vistas](#personalización-de-vistas)
- [Uso](#uso)
  - [Filtros de controlador y helpers](#filtros-de-controlador-y-helpers)
  - [Helper methods](#helper-methods)
  - [Rutas](#rutas)
- [Generadores disponibles](#generadores-disponibles)
- [Instalación de requerimientos](#instalación-de-requerimientos)
    - [TailwindCSS](#tailwindcss)
    - [Stimulus](#stimulus)
- [Licencia](#licencia)

## Requerimientos previos

Es necesario tener instalado lo siguiente:

 - TailwindCSS (vía Webpack, Bundling, PostCSS o la gema de Rails).
 - Stimulus (vía Webpack, Bundling o Importmaps.)

En caso de no contar con ellos, puedes ver un ejemplo de la instalación de dichos requerimientos en [Instalación de requerimientos](#instalación-de-requerimientos).

## Instalación

NoPassword es un engine de Rails. Probado con Rails `>= 7.0.1` y Ruby `>= 3.0.2`

Añade la siguiente línea a tu Gemfile:
```ruby
gem "no_password"
```
o bien puedes instalar la gema directamente desde el repositorio de github con:
```ruby
gem "no_password", git: "https://github.com/creditario/no_password.git"
```

Después ejecuta `bundle`.

Usa el siguiente comando para instalar y configurar el engine en tu aplicación:

```bash
$ rails no_password:install
```

Ejecuta las migraciones:
```bash
$ bin/rails db:migrate
```

## Configuración

NoPassword te redirige por default al `root_path` de tu aplicación cuando inicias y cierras sesión. Debido a esto es necesario que configures tu `root_path` en `config/routes.rb`.

Este es un ejemplo:
```bash
  root to: "home#index"
```

### Configurar idiomas
NoPassword funciona en español, es necesario que en `config/application.rb` tengas habilitado el idioma español, utiliza las siguientes líneas:
```bash
config.i18n.default_locale = :es
config.i18n.available_locales = [:en, :es]
```

### Configuración para emails
Para el correcto funcionamiento de los assets dentro de los emails es necesario establecer `asset_host` para action_mailer.

También asegurate de tener declarado un host para `default_url_options` en tus archivos de `config/enviroments`(`development.rb`, `production.rb` y `test.rb`).

Aquí tienes un ejemplo de como declarar ambas configuraciones para el environment de `development.rb`:
```bash
config.action_mailer.default_url_options = { host: "localhost", port: 3000 }
config.action_mailer.asset_host = "http://localhost:3000"
```

### Uso de letter opener

Es recomendado utilizar la gema [letter opener](https://github.com/ryanb/letter_opener) para poder tener acceso a los emails cuando se hacen pruebas en ambiente de desarrollo.

Añade la siguiente línea a tu Gemfile:
```bash
gem "letter_opener", group: :development
```

Utiliza `bundle` para instalar la gema letter_opener.

Asegurate de tener declarado `:letter_opener` como `delivery_method` y `perform_deliveries` igual a `true`, en `config/enviroments/development.rb`:
```bash
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
```

### Personalización de vistas

Para personalizar las vistas de la gema, utiliza este comando que copia las vistas del engine dentro de tu aplicación. Los archivos se generan dentro de `views/no_password` y `views/layouts/no_password`.

```bash
$ rails no_password:install:copy_templates
```

## Uso

El inicio de sesión puede hacerse por medio de un link mágico presente en el email o mediante el token adjunto, ingresándolo en el formulario de la ruta: `/no_password/confirmations`.

Ambos métodos redireccionan al `root_path` default de tu aplicación.

### Filtros de controlador y helpers

NoPassword incluye algunos helpers, disponibles para su uso en tus controladores y vistas.

Para añadir la autenticación a una acción en un controlador, solamente necesitas añadir este `before_action`:

```bash
  before_action :authenticate_session!, only: [:show]
```

### Helper methods

Puedes usar `signed_in_session?` y `current_session` en tus controladores, vistas y helpers.

Usa el siguiente helper para verificar si hay una sesión iniciada:

```bash
  signed_in_session?
```

Con este helper puedes obtener la sesión actual y su información:
```bash
  current_session
```

Este es un ejemplo de como se usan en las vistas:

```erb
<% if signed_in_session? %>
  <%= current_session.email %>
  <%= button_to "Sign out", no_password.session_path(current_session.id), method: :delete %>
<% else %>
  <%= link_to "Sign in", no_password.new_session_path %>
<% end %>
```

Al finalizar la instalación y configuración de la gema puedes probar tu aplicación con el comando `./bin/dev`
```bash
$ ./bin/dev
```

### Rutas

Por default, NoPassword tiene tres rutas principales:

Para iniciar sesión, el path `no_password.new_session_path` muestra la vista para introducir un email, al que será enviado un token único y expirable:

```bash
   <%= no_password.new_session_path %> # => /no_password/sessions/new #
```

Para ingresar el token, el path `no_password.edit_session_confirmations_path` muestra la vista con el formulario:

```bash
   <%= no_password.edit_session_confirmations_path %> # => /no_password/confirmations #
```

Para cerrar sesión es necesario enviar `current_session.id` al path `no_password.session_path` con el método `delete`:
```bash
   <%= button_to "Sign out", no_password.session_path(current_session.id), method: :delete %>
```

## Generadores disponibles

### Instala el engine NoPassword.

```bash
$ rails no_password:install
```
- Agrega la ruta para montar el engine.
- Agrega los concerns al ApplicationController.
- Copia las migraciones del engine.
- Genera el archivo de CSS de Tailwind.

### Copia los templates de no_password a tu aplicación.

```bash
$ rails no_password:install:copy_templates
```
- Copia los templates de layouts, vistas y mailers a la
aplicación principal para permitir la personalización.

### Copia migraciones de no_password a tu aplicación.

```bash
$ rails no_password:install:migrations
```
### Genera tu Tailwind CSS.

```bash
$ rails no_password:tailwindcss:build
```
- Se genera localmente al momento de instalar y se
puede regenerar en cualquier momento.
- Se integra al proceso de compilación de assets en
producción.

###  Autogenera el CSS.

```bash
$ rails no_password:tailwindcss:watch
```
- En modo de desarrollo de la gema se autogenera el CSS.

## Instalación de requerimientos

### TailwindCSS
en caso de que tu aplicación no cuente con TailwindCSS, te recomendamos instalar la gema de [tailwindcss-rails](https://github.com/rails/tailwindcss-rails) en tu aplicación.

Corre los siguientes comandos para instalarlo.
```bash
$ ./bin/bundle add tailwindcss-rails
```
```bash
$ ./bin/rails tailwindcss:install
```
### Stimulus

Si tu aplicación usa una versión de Rails 7 o mayor, Stimulus está automáticamente configurado en tu aplicación. En caso de no contar con Stimulus, te recomendamos instalar la gema [stimulus-rails](https://github.com/hotwired/stimulus-rails).

Una vez finalizada la instalación de los requerimientos continua con la [instalación de la gema](#instalación) .

## Licencia
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
