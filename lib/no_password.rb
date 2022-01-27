require "no_password/version"
require "no_password/engine"
require "no_password/railtie"
require "importmap-rails"

module NoPassword
  class << self
    attr_accessor :configuration
  end

  class Configuration
    attr_accessor :session_name, :session_expiration, :session_domain, :secret_key, :tailwind_content, :importmap

    def initialize
      @session_name = "_session"
      @session_expiration = 15
      @session_domain = nil
      @secret_key = nil
      @importmap = Importmap::Map.new

      @tailwind_content = [
        "#{NoPassword::Engine.root}/app/views/**/*",
        "#{NoPassword::Engine.root}/app/helpers/**/*",
        "#{NoPassword::Engine.root}/app/controllers/**/*",
        "#{NoPassword::Engine.root}/app/javascript/**/*.js",
        "#{NoPassword::Engine.root}/app/assets/**/application.tailwind.css"
      ]
    end
  end

  def self.init_config
    self.configuration ||= Configuration.new
  end

  def self.configure
    init_config
    yield(configuration)
  end
end

NoPassword.init_config
