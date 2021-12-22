# frozen_string_literal: true

module NoPassword
  class SessionsController < ApplicationController
    include Concerns::WebTokens

    def new
      session[:referrer_path] = referrer_path

      @resource = Session.new
    end

    def create
      current_session = SessionManager.new.create(request.user_agent, params.dig(:session, :email), request.remote_ip, session[:referrer_path])

      if current_session.present?
        SessionsMailer.with(session: current_session).send_token.deliver_now
      end
    end

    private

    def referrer_path
      return nil if request.referer.blank?

      return_path = URI(request.referrer).path
      return_path == no_password.new_session_path ? nil : return_path
    end
  end
end
