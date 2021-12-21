module NoPassword
  class SessionsMailer < ApplicationMailer
    include Concerns::SignTokens

    def send_token
      @session = params[:session]
      @title = t("mailers.send_token.subject")
      @token = @session.token
      @friendly_token = verify_signed_token(@session.token)

      mail(to: @session.email, from: t("layouts.mailer.from"), subject: t("mailers.send_token.subject"))
    end
  end
end
