module NoPassword
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    def create_initializer_file
      template "config/initializers/no_password.rb"
    end

    def add_route
      return if Rails.application.routes.routes.detect { |route| route.app.app == NoPassword::Engine }
      route %(mount NoPassword::Engine => "/p")
    end

    def add_concerns
      inject_into_file "app/controllers/application_controller.rb", after: "ActionController::Base" do
        <<~EOF
          \n  include NoPassword::ControllerHelpers
        EOF
      end
    end

    def copy_migrations
      rake "no_password:install:migrations"
    end

    def build_tailwind
      rake "no_password:tailwindcss:build"
    end
  end
end
