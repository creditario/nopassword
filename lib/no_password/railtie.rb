module NoPassword
  class Railtie < Rails::Railtie
    initializer "no_password.assets.precompile" do |app|
      app.config.assets.precompile += %w[no_password/manifest]
    end
  end
end
