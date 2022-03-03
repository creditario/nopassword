# frozen_string_literal: true

module NoPassword
  class SessionConfirmationsController < ApplicationController
    include Concerns::ControllerHelpers
    include Concerns::WebTokens

    def edit
      if params[:token].present?
        friendly_token = verify_token(params[:token])

        current_session = find_and_validate_token(friendly_token)

        if !current_session.present? && respond_to?(:custom_redirect)
          custom_redirect
        elsif current_session.present?
          sign_in_session(current_session)
        end
      end
    end

    def update
      current_session = find_and_validate_token(params[:token])

      if !current_session.present? && respond_to?(:custom_redirect)
        custom_redirect
      elsif current_session.present?
        sign_in_session(current_session)
      else
        response.status = :unprocessable_entity
        render turbo_stream: turbo_stream.update("notifications", partial: "notification")
      end
    end

    private

    def nopassword_sign_in(session_model, key = nil, data = nil)
      if session_model.claimed? && !session_model.expired?
        session[session_key] = session_model.id

        if key.present? && data.present?
          session[session_key(key)] = data
        end
        session_model
      end
    end

    def sign_in_session(session)
      claimed_session = SessionManager.new.claim(session.token, session.email)
      nopassword_sign_in(claimed_session)

      if respond_to?(:force_device_login)
        force_device_login
      else
        redirect_to session.return_url || main_app.root_path
      end
    end

    def find_and_validate_token(friendly_token)
      session = Session.find_by(token: friendly_token)

      if session.nil? || session&.invalid?
        flash.now.alert = t("flash.update.invalid_code.alert")
        return nil
      end

      session
    end
  end
end
