require "no_password/version"
require "no_password/engine"

module NoPassword
  class << self
    attr_accessor :configuration
  end

  class Configuration
    attr_accessor :session_name, :session_expiration, :session_domain

    def initialize
      @session_name = "_session"
      @session_expiration = 15.minutes
      @session_domain = nil
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
