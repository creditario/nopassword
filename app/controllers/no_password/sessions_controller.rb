# frozen_string_literal: true

module NoPassword
  class SessionsController < ApplicationController
    include Concerns::ControllerHelpers

    def new
      @return_to = params[:return_to].to_s
      @resource = Session.new
    end

    def create
      return_to = params[:return_to].to_s
      current_session = SessionManager.new.create(request.user_agent, params.dig(:session, :email), request.remote_ip, referrer_path(return_to))

      if current_session.present?
        SessionsMailer.with(session: current_session).send_token.deliver_now

        after_session_request if respond_to?(:after_session_request)

        respond_to do |format|
          format.html { redirect_to no_password.edit_session_confirmations_path }
          format.turbo_stream
        end
      end
    end

    def destroy
      sign_out
      redirect_to main_app.root_path
    end

    private

    def referrer_path(return_to)
      referrer = CGI.unescape(return_to)
      return nil if referrer.blank?

      referrer.include?(no_password.new_session_path) || referrer.include?(no_password.edit_session_confirmations_path) ? nil : referrer
    end

    def sign_out(key = nil)
      session.delete(session_key)
      session.delete(session_key(key)) if key.present?
      @session = nil
      true
    end
  end
end
