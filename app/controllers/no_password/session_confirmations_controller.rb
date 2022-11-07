# frozen_string_literal: true

module NoPassword
  class SessionConfirmationsController < ApplicationController
    include NoPassword::ControllerHelpers
    include NoPassword::WebTokens

    def edit
      if params[:token].present?
        token = verify_token(params[:token])

        sign_in_session(token, true)
      end
    end

    def update
      result = sign_in_session(params[:token])
      return result if result.present?

      response.status = :unprocessable_entity
      render turbo_stream: turbo_stream.update("notifications", partial: "notification")
    end

    private

    def sign_in_session(token, by_url = false)
      current_session = SessionManager.new.claim(token)

      flash.now.alert = t("flash.update.invalid_code.alert") if current_session.blank?

      result = if respond_to?(:after_sign_in!)
        after_sign_in!(current_session.present?, by_url, current_session&.return_url)
      elsif current_session.present?
        save_session_to_cookie(current_session)
        redirect_to(current_session.return_url || main_app.root_path)
      end

      result if result.present?
    end

    def save_session_to_cookie(current_session, key = nil, data = nil)
      session[session_key] = current_session.id
      session[session_key(key)] = data if key.present? && data.present?
    end
  end
end
