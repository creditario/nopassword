# frozen_string_literal: true

module NoPassword
  class SessionConfirmationsController < ApplicationController
    include Concerns::ControllerHelpers
    include Concerns::WebTokens

    def edit
      if params[:token].present?
        friendly_token = verify_token(params[:token])

        sign_in_session(friendly_token, true)
      end
    end

    def update
      result = sign_in_session(params[:token])
      return result if result.present?

      response.status = :unprocessable_entity
      render turbo_stream: turbo_stream.update("notifications", partial: "notification")
    end

    private

    def sign_in_session(friendly_token, by_url = false)
      current_session = find_and_validate_token(friendly_token)

      result = if current_session.blank? && respond_to?(:after_sign_in!)
        after_sign_in!(false, by_url)
      elsif current_session.present?
        claim_session(current_session, by_url)
      end

      result if result.present?
    end

    def claim_session(session, by_url = false)
      claimed_session = SessionManager.new.claim(session.token, session.email)
      save_session_to_cookie(claimed_session)

      return after_sign_in!(true, by_url) if respond_to?(:after_sign_in!)

      redirect_to session.return_url || main_app.root_path
    end

    def save_session_to_cookie(session_model, key = nil, data = nil)
      if session_model.claimed? && !session_model.expired?
        session[session_key] = session_model.id
        session[session_key(key)] = data if key.present? && data.present?

        session_model
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
