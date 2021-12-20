module NoPassword
  class SessionsMailer < ApplicationMailer
    sig { void }
    def send_token
      @session = params[:session]
      @token = @session.token

      mail(to: @session.email, subject: t("mailers.reset_password.subject"))
    end
  end
end
