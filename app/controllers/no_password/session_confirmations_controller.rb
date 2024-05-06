# frozen_string_literal: true

module NoPassword
  class SessionConfirmationsController < ApplicationController
    include NoPassword::ControllerHelpers
    include NoPassword::WebTokens

    def edit
      return unless params[:token].present?

      token = verify_token(params[:token])
      redirect_url = sign_in_session(token, by_url: true)

      redirect_to(redirect_url) if redirect_url.present?
    end

    def update
      redirect_url = sign_in_session(params[:token])

      return redirect_to(redirect_url) if redirect_url.present?

      response.status = :unprocessable_entity
      render turbo_stream: turbo_stream.update("notifications", partial: "notification")
    end

    private

    def claim_session(token)
      current_session = SessionManager.new.claim(token)
      if current_session.present?
        save_session_to_cookie(current_session)
      else
        flash.now.alert = t("flash.update.invalid_code.alert")
      end

      current_session
    end

    def sign_in_session(token, by_url: false)
      current_session = claim_session(token)

      if respond_to?(:after_sign_in!)
        after_sign_in!(current_session, by_url)
      elsif current_session.present?
        current_session.return_url || main_app.root_path
      end
    end

    def save_session_to_cookie(current_session, key = nil, data = nil)
      session[session_key] = current_session.id
      session[session_key(key)] = data if key.present? && data.present?
    end
  end
end
