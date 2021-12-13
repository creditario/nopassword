require "uri"

module NoPassword
  class SessionsController < ApplicationController
    before_action :setup_referrer_path, only: [:new]
    helper_method :referrer_path

    def referrer_path
      @@referrer_path
    end

    def setup_referrer_path
      @@referrer_path = validate_referrer_path
      puts "*********referrer prueba: #{@@referrer_path}"
    end

    def new
      @resource = Session.new
    end
    
    def create
      user_agent = request.user_agent
      email = params.dig(:session, :email)
      remote_addr = request.remote_ip
      # @referrer_path = validate_referrer_path

      session = SessionManager.new

      session.create(user_agent, email, remote_addr, @@referrer_path)

      redirect_to edit_sessions_confirmation_path
    end
    
    private
     
    def validate_referrer_path
      referrer_path = URI(request.referer).path if request.referer.present?
      
      if self_path?(referrer_path) || external_link?(referrer_path)
        return nil
      else
        return referrer_path
      end
    end

    def self_path?(referrer_path)
      referrer_path == no_password.new_session_path 
    end

    def external_link?(referrer_path)
      referrer_path[1] != 'p'
    end
  end
end
