# frozen_string_literal: true

module NoPassword
  class SessionsController < ApplicationController
    def new
      session[:referrer_path] = referrer_path

      @resource = Session.new
    end

    def create
      SessionManager.new.create(request.user_agent, params.dig(:session, :email), request.remote_ip, session[:referrer_path])
    end

    private

    def referrer_path
      return nil unless request.referer.present?

      return_path = request.referer
      self_path?(return_path) || external_path?(return_path) ? nil : return_path
    end

    def self_path?(return_path)
      URI(return_path).path == no_password.new_session_path
    end

    def external_path?(return_path)
      URI(return_path).host != request.host
    end
  end
end
