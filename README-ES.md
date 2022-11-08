# NoPassword

NoPassword es una gema de Ruby on Rails que realiza autenticación de sesiones a través de token o link mágico enviado a correo electrónico de usuario, no se necesitan contraseñas.

## Tabla de contenido

- [Requerimientos](#requerimientos)
- [Instalación](#instalación)
- [Configuración](#configuración)
    - [Inicializador](#configurar-inicializador)
    - [Configurar idiomas](#configurar-idiomas)
    - [Configuración para emails](#configuración-para-emails)
    - [Personalización de vistas](#personalización-de-vistas)
- [Uso de NoPassword](#uso-de-nopassword)
  - [Filtros de controlador](#filtros-de-controlador)
  - [Helper methods](#helper-methods)
  - [Callback](#callback)
- [Generadores](#generadores)
- [Desarrollo y pruebas de la gema](#desarrollo-y-pruebas-de-la-gema)
- [Licencia](#licencia)

## Requerimientos

NoPassword es un Rails Engine que requiere de Ruby on Rails 7.0 o mejor, así como Ruby 3.0.2 o mejor para funcionar.
NoPassword tiene dos vistas, una para solicitar un token o código y otra para ingresar el token. Las dos vistas hacen uso de TailwindCSS via la gema [tailwindcss-rails](https://github.com/rails/tailwindcss-rails) y de StimulusJS a través de Importmaps.

En caso de requieras personalizar la forma en como se sirven los assets, por ejemplo, con Webpacker o los Bundlings de Rails, entonces puedes realizar la [Personalización de vistas](#personalización-de-vistas) para ajustarlas a tus necesidades.

## Instalación

Para instalar NoPassword solamente hay que añadir la gema a tu `Gemfile`.
```ruby
gem "no_password"
```
También puedes instalar la gema directamente desde el repositorio de github con:
```ruby
gem "no_password", git: "https://github.com/creditario/nopassword.git"
```

En ambos casos hay que ejecutar `bundle` para instalar la dependencia.

El siguente paso consiste en instalar las migraciones y el archivo inicializador de NoPassword.

```bash
$ bin/rails no_password:install
```
Recuerda ejecutar las migraciones antes de continuar.
```bash
$ bin/rails db:migrate
```

En la siguiente sección se explicará las opciones de configuración de NoPassword mediante su inicializador.

## Configuración
Al instalar NoPassword automáticamente el Engine se monta en `/p` dentro del archivo `config/routes.rb`.

### Configurar inicializador
NoPassword provee un inicializador en `config/initializers/no_password.rb`. Aquí es posible cambiar el comportamiento de la expiración de la sesión después de haber iniciado, por omisión expira después de dos horas `session_expiration`. Otra opción disponible es indicar en cuanto tiempo expira un token que no ha sido reclamado, por omisión expira en 15 minutos `token_expiration`.

`secret_key` permite configurar la llave que firma las URLs de los links mágicos para iniciar sesión. Si el valor es nulo, entonces hace uso del `secret_key` de Ruby on Rails.

```ruby
NoPassword.configure do |config|
  # Session expiration time
  # config.session_expiration = 2.hours
  #
  # Token expiration time
  # config.token_expiration = 15.minutes
  #
  # Secret key to cypher tokens, if none, then Rails secret key is used
  # config.secret_key = nil
end
```

### Configurar idiomas
NoPassword cuenta con archivos de traducción para español (`:es`) e inglés (`:en`). El idioma en que se muestre dependederá de la configuración en tu `config/application.rb`. Ejemplo.

```ruby
config.i18n.default_locale = :es
config.i18n.available_locales = [:en, :es]
```

### Configuración para emails
ActionMailer es utilizado por la gema para enviar el correo electrónico con el token y el link mágico. Los correos se envian con la ayuda de ActiveJob cuando existe alguna estrategía configurada para este como caso, por ejemplo [Sidekiq](https://sidekiq.org).

Recuerda en producción configurar correctamente `default_url_options` y `asset_host` en tu archivo `config/enviroments/production.rb`.

```ruby
config.action_mailer.default_url_options = { host: "my-domain.com" }
config.action_mailer.asset_host = "https://my-domain.com"
```

En modo de desarrollo es útil contar con una gema como [letter opener](https://github.com/ryanb/letter_opener) que evite el envío de correos electrónicos y que en su lugar los abra en línea. Para este caso agrega la gema a tu `Gemfile` y ejecuta el comando `bundle`.

```ruby
gem "letter_opener", group: :development
```

Abre tu archivo `config/enviroments/development.rb` y configurala de la siguiente forma:

```ruby
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = true
```

### Personalización de vistas
Este paso no es necesario, con los pasos anteriores se obtienen las vistas default de la gema, pero si así lo requieres puedes personalizar las vistas de la gema, utiliza este comando que copia las vistas del engine dentro de tu aplicación. Los archivos se generan dentro de `views/no_password` y `views/layouts/no_password`.

```bash
$ rails no_password:install:copy_templates
```

## Uso de NoPassword
Después de instalar NoPassword para utilizarla en tu aplicación se proporcionan filtros y **helpers** que te permiten conocer si existe una sesión activa o no, y en su defecto, enviar al usuario a crear una sesión antes de continuar.

### Filtros de controlador
El filtro `authenticate_session!` se incluye en el módulo `NoPassword::ControllerHelpers`. Este filtro es utilizado en un `before_action` para determinar en un controlador si existe una sesión activa o no. En el caso de no existir, el usuario es redirigido a la sección de NoPassword donde podrá solicitar un token de acceso.

Para hacer uso del filtro hay que incluir el módulo en el controlador deseado y agregar el `before_action`.

```ruby
  include NoPassword::ControllerHelpers
  before_action :authenticate_session!
```

### Helper methods
El módulo `NoPassword::ControllerHelpers` incluye los métodos `signed_in_session?` y `current_session` para consultar si existe una sesión activa y obtener más información de la sesión, respectivamente. Cuando el módulo de incluye en un controlador estos métodos se exponen en el contexto de las vistas.

Ejemplo de uso en una vista.

```erb
<% if signed_in_session? %>
  <%= current_session.email %>
  <%= button_to "Sign out", no_password.session_path(current_session.id), method: :delete %>
<% else %>
  <%= link_to "Sign in", no_password.new_session_path %>
<% end %>
```

### Callback
El flujo normal para iniciar sesión consta de dos pasos, una página donde se introduce el correo electrónico para solicitar un código y/o el link mágico, otra página donde se introduce el código, sin embargo pueden existir casos que se salgan de esta flujo propuesto por NoPassword. Para situaciones donde se desea forzar a donde dirigir al usuario después de iniciar sesión o cuando el link mágico es inválido, o simular **Single Page Application** tenemos a nuestra disposición el callback `after_sign_in!`.

![Aoorora Demo page](docs/aoorora-demo.gif)

Este callback va a ser llamado en cada intento de iniciar sesión, ya sea con código o con link mágico, independientemente de si el inicio de sesión es exitoso o no.
```ruby
after_sign_in!(signed_in, by_url, return_url)
```
El callback recibe 3 parámetros.
- `signed_in`: indica si fue exitoso el inicio de sesión o no, su valor es booleano.
- `by_url`: indica como se inentó iniciar sesión, ya sea por el link mágico o con el código introducido manualmente, su valor es booleano.
- `return_url`: Contiene la URL a donde redireccionar al usuario en caso de que el inicio de sesión sea exitoso, su valor es una cadena de texto.

El controlador `SessionConfirmationsController` espera como respuesta del callback los siguientes posibles valores:
- `nil`: con el cual se indica que se ejecutó el callback y que regresa el control del flujo al controlador.
- `render` o `redirect_to`: en este caso le indicamos al controlador que el callback toma el control del flujo.

Podemos implementar el callback `after_sign_in!` creando el archivo `app/controllers/no_password/session_confirmations_controller.rb` en nuestra aplicación principal,
donde cargamos el controlador original desde el engine de NoPassword y con `class_eval` le inyectamos el método.

```ruby
load NoPassword::Engine.root.join("app", "controllers", "no_password", "session_confirmations_controller.rb")

NoPassword::SessionConfirmationsController.class_eval do
  def after_sign_in!(signed_in, by_url)
    return do_something_different if signed_in # Do something different if user signed in successfully
    return nil if !by_url # Return control if failed to sign in with magic link

    flash[:alert] = "Your code is not valid"
    redirect_to main_app.demo_path # Redirect somewhere else if token is invalid
  end
end
```

## Generadores
La gema NoPassword cuenta con 4 generadores de Ruby on Rails, el primero de ellos es el que se encarga de realizar la instalación y realiza las siguientes acciones.

- Crea el archivo de inicialización
- Monta el engine en las rutas de aplicación
- Incluye los **helpers** de la gema en `ApplicationController`.
- Copia las migraciones de NoPassword a la aplicación.
- Genera el archivo de CSS de la gema.

```bash
$ rails no_password:install
```
Para los casos de requerir personalizar las vistas de la gema, el generador `copy_templates` se encarga de copiar **layouts**, vistas y plantillas de **mailers** a `app/views`, colocando los archivos donde corresponden bajo el directorio `no_password`.

```bash
$ rails no_password:install:copy_templates
```

El generador `migrations` se encarga de copiar las migraciones desde la gema hacia la aplicación.

```bash
$ rails no_password:install:migrations
```

Los generadores `tailwindcss::build` y `tailwindcss:watch` trabajan en conjunto para generar el CSS basado en Tailwind desde la gema y exponerlo a la aplicación, en ambos casos se generar un archivo `tailwind.config.js` específico para la gema y que Tailwind utiliza para generar el CSS necesario.
```bash
$ rails no_password:tailwindcss:build
```
Este generador `tailwindcss::build` se conecta automática al proceso de compilación de assets en modo de producción.

```bash
$ rails no_password:tailwindcss:watch
```
El generador `tailwindcss:watch` se usa en modo de desarrollo y se puede agregar al `Procfile.dev` ejecutar el proceso y monitorear posibles cambios al CSS de la gema.

```ruby
no_password_css: bin/rails app:no_password:tailwindcss:watch
```

## Desarrollo y pruebas de la gema
Para generar un ambiente de desarrollo de la gema, primero es necesario clonar este repositorio. Una vez clonado, el script `bin/setup` se encarga de instalar la dependencias y migrar la base de datos. Además supone que [Overmind](https://github.com/DarthSim/overmind) está instalado por lo que usa la configuración del archivo `Procfile.dev` para iniciar la aplicación de prueba en el puerto 3090.

```bash
$ bin/setup
```

![Aoorora Demo page](docs/dummy-app.png)

Para ejecutar la pruebas de la gema y ejecutar los linters se puede hacer uso del script `bin/ci`.

```bash
$ bin/ci
```

## Licencia
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
