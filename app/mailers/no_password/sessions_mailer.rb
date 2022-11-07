# frozen_string_literal: true

module NoPassword
  class SessionsMailer < ApplicationMailer
    include NoPassword::WebTokens

    def send_token
      @session = params[:session]
      @title = t("mailers.send_token.subject")
      @friendly_token = @session.token
      @signed_token = token_to_url(sign_token(@friendly_token))

      mail(to: @session.email, subject: t("mailers.send_token.subject"))
    end
  end
end
