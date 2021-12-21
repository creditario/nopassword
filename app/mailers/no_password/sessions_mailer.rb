module NoPassword
  class SessionsMailer < ApplicationMailer
    include Concerns::WebTokens

    def send_token
      @session = params[:session]
      @title = t("mailers.send_token.subject")
      @signed_token = token_to_url(@session.token)
      @friendly_token = verify_token(token_from_url(@signed_token))

      mail(to: @session.email, from: t("layouts.mailer.from"), subject: t("mailers.send_token.subject"))
    end
  end
end
