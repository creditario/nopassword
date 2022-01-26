# NoPassword

NoPassword permite realizar autenticación de sesiones con un token o un link mágico enviado a tu email, sin necesidad de contraseñas.

## Tabla de contenido

- [Requerimientos previos](#requerimientos-previos)
- [Instalación](#instalación)
    - [Instalación de assets del engine](#instalación-de-assets-del-engine)
- [Configuración](#configuración)
    - [Montar engine](#montar-engine)
    - [Configurar idiomas](#configurar-idiomas)
    - [Configuración para emails](#configuración-para-emails)
      - [Uso de letter opener](#uso-de-letter-opener)
    - [Configuración de Tailwind](#configuración-de-tailwind)
- [Uso](#uso)
	- [Filtros de controlador y helpers](#filtros-de-controlador-y-helpers)
	- [Helper methods](#helper-methods)
	- [Rutas](#rutas)
- [Instalación de requerimientos](#instalación-de-requerimientos)
    - [Instalación de Tailwind](#instalación-de-tailwind)
    - [Instalación de Stimulus](#instalación-de-stimulus)
    - [Scripts](#scripts)
- [Licencia](#licencia)

## Requerimientos previos

Es necesario tener instalado lo siguiente:

 - TailwindCSS (vía Webpack, Bundling, PostCSS).
 - Ejecutar los [scripts](#scripts) de JS y CSS (vía Webpack, los Bundlings (JS/CSS) o importmaps y postcss).
 - Stimulus (vía Webpack, Bundling o Importmaps.)

En caso de no contar con ellos, puedes ver un ejemplo de la instalación de dichos requerimientos en [Instalación de requerimientos](#instalación-de-requerimientos).

## Instalación

NoPassword es un engine de Rails. Probado con Rails `>= 7.0.0.alpha2` y Ruby `>= 3.0.2`

Añade la siguiente línea a tu Gemfile:
```ruby
gem 'no_password'
```

Después ejecuta el siguiente comando para instalarlo:
```bash
$ bundle
```

Corre las migraciones
```bash
$ bin/rails no_password:install:migrations
```

```bash
$ bin/rails db:migrate
```

### Instalación de assets del engine

Usa el siguiente comando para instalar los assets del engine en tu aplicación:

* Nota: cada vez que se haga un cambio a los archivos assets
en la gema se debe de ejecutar este instalador.
```bash
$ bin/rails no_password:install:assets
```

Es necesario importar los controladores de JS `"./no_password/controllers"` dentro de `application.js`:
```bash
import "./no_password/controllers" 
```

Para los assets de CSS asegúrate importar `"./no_password/config.css"` en `application.css`:
```bash
@import "./no_password/config.css";
```

Asegurate de tener estás dos líneas de código en tu `manifest.js`
```bash
//= link no_password_manifest.js
//= link_tree ../builds
```

## Configuración

### Montar engine
Para montar el engine en tu aplicación copia la siguiente línea en `config/routes.rb`
```bash
  mount NoPassword::Engine => "/no_password"
```

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

Es recomendado utilizar la gema `letter opener` para poder tener acceso a los emails cuando se hacen pruebas en ambiente de desarrollo.

Añade la siguiente línea a tu Gemfile:
```bash
gem "letter_opener", group: :development
```

Utiliza bundle para instalar la gema letter_opener:
```bash
$ bundle
```

Asegurate de tener declarado `:letter_opener` como `delivery_method` y `perform_deliveries` igual a `true`, en `config/enviroments/development.rb`:
```bash
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
```

### Configuración de Tailwind

Para configurar el archivo `tailwind.config.js` utiliza el siguiente comando:

```bash
$ bin/rails app:template LOCATION=https://raw.githubusercontent.com/armandoescalier/engines_views_setup/main/engines_views_setup.rb
```

El archivo `tailwind.config.js` debe estar ubicado en la raíz de tu proyecto para que la configuración se realice correctamente.

## Uso

El inicio de sesión puede hacerse por medio de un link mágico presente en el email o mediante el token adjunto, ingresándolo en el formulario de la ruta: `/no_password/confirmations`. 

Ambos métodos redireccionan al `root_path` default de tu aplicación.

### Filtros de controlador y helpers

NoPassword incluye algunos helpers, disponibles para su uso en tus controladores y vistas. 

Para acceder a los helpers es necesario añadir la siguiente línea en `controllers/application_controller.rb`:
```bash
  include NoPassword::Concerns::ControllerHelpers
```

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

## Instalación de requerimientos

Aquí se muestra como instalar JS Y CSS Bundling, TailwindCSS, PostCSS y Stimulus, en caso de que tu aplicación no cuente con ellos, ya que son necesarios para el funcionamiento de la gema NoPassword.

Añade las siguiente gemas a tu `Gemfile`:
```bash
gem "jsbundling-rails"
gem "cssbundling-rails"
gem "turbo-rails"
```

Utiliza el comando `bundle` para instalarlas.

Los siguientes comandos son necesarios para configurar las gemas:

Para esbuild:
```bash
$ ./bin/rails javascript:install:esbuild
```
Para PostCSS:
```bash
$ ./bin/rails css:install:postcss
```
Para turbo:
```bash
$ ./bin/rails turbo:install
```

### Instalación de Tailwind:

```bash
$ yarn add tailwindcss@latest @tailwindcss/forms postcss-import postcss-nesting
```

En el archivo `postcss.config.js` asegúrate de tener lo siguiente:
```bash
module.exports = {
  plugins: [
    require('postcss-import'),
    require('tailwindcss/nesting')(require('postcss-nesting')),
    require('tailwindcss'),
    require('autoprefixer'),
  ],
}
```

A continuación es necesario crear el archivo `tailwind.config.js` en la raíz de tu proyecto.

Cambia el nombre del archivo `assets/stylesheets/application.postcss.css` por `assets/stylesheets/application.css` y añade este código:
```bash
@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";
```

### Instalación de Stimulus

Para instalar Stimulus utiliza el siguiente comando:
```bash
$ yarn add esbuild esbuild-rails @hotwired/stimulus @hotwired/turbo-rails stimulus-use@beta
```

A continuación crea el archivo `esbuild.config.js` en la raíz de tu proyecto con este código:

```bash
const path = require('path')
const rails = require('esbuild-rails')
require("esbuild").build({
  entryPoints: ["application.js"],
  bundle: true,
  outdir: path.join(process.cwd(), "app/assets/builds"),
  absWorkingDir: path.join(process.cwd(), "app/javascript"),
  watch: process.argv.includes("--watch"),
  plugins: [rails()],
}).catch(() => process.exit(1))
```

### Scripts

Asegurate de añadir los siguientes scripts a tu archivo `package.json`:

```bash
  "scripts": {
    "build": "node esbuild.config.js",
    "build:css": "postcss ./app/assets/stylesheets/application.css -o ./app/assets/builds/application.css"
  }
```

Una vez finalizada la instalación de los requerimientos continua con la [instalación de la gema](#instalación) .

## Licencia
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).