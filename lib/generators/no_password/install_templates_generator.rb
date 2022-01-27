module NoPassword
  class InstallTemplatesGenerator < Rails::Generators::Base
    source_root File.expand_path("../../../app/views", __FILE__)

    def copy_layout
      empty_directory "app/views/layouts/no_password"
      directory File.join(engine_views_path, "layouts", "no_password"),
        File.join(app_views_path, "layouts", "no_password")
    end

    def copy_views
      empty_directory "app/views/no_password"
      directory File.join(engine_views_path, "no_password"),
        File.join(app_views_path, "no_password")
    end

    private

    def engine_views_path
      @engine_views_path ||= File.join(NoPassword::Engine.root, "app", "views")
    end

    def app_views_path
      @app_views_path ||= File.join(Rails.root, "app", "views")
    end
  end
end
