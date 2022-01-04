# frozen_string_literal: true

module NoPassword
  class SessionConfirmationsController < ApplicationController
    include Concerns::ControllerHelpers
    include Concerns::WebTokens

    def edit
      if params[:token].present?
        friendly_token = verify_token(params[:token])
        session = Session.find_by(token: friendly_token)

        if session.nil?
          response.status = :unprocessable_entity
          return redirect_to no_password.edit_session_confirmations_path, alert: t("flash.update.invalid_code.alert")
        end

        if session.claimed? || session.expired?
          redirect_to no_password.new_session_path
        else
          SessionManager.new.claim(session.token, session.email)
          sign_in(session)

          redirect_to session.return_url || main_app.root_path
        end
      end
    end

    def update
      @resource = Session.find_by(token: params[:token])

      if @resource.nil?
        response.status = :unprocessable_entity
        flash.now.alert = t("flash.update.invalid_code.alert")

        return render turbo_stream: turbo_stream.update("notifications", partial: "notification")
      end

      if @resource.claimed? || @resource.expired?
        redirect_to no_password.new_session_path
      else
        SessionManager.new.claim(@resource.token, @resource.email)
        sign_in(@resource)

        redirect_to @resource.return_url || main_app.root_path
      end
    end
  end
end
