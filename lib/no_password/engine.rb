require "importmap-rails"

module NoPassword
  class Engine < ::Rails::Engine
    isolate_namespace NoPassword

    initializer "no_password.importmap", before: "importmap" do |app|
      app.config.importmap.paths << Engine.root.join("config/initializers/importmap.rb")
    end
  end
end
