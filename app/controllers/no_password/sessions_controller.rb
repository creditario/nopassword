# frozen_string_literal: true

module NoPassword
  class SessionsController < ApplicationController
    include Concerns::SignTokens

    def new
      session[:referrer_path] = referrer_path

      @resource = Session.new
    end

    def create
      email = params.dig(:session, :email)
      SessionManager.new.create(request.user_agent, email, request.remote_ip, session[:referrer_path])

      session = NoPassword::Session.find_by(email: email)

      if session.present?
        session.update(token: sign_token(session.token))
        SessionsMailer.with(session: session).send_token.deliver_now
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
