module NoPassword
  class ApplicationMailer < ActionMailer::Base
    default from: I18n.t("mailers.default_from")
    layout "no_password/mailer"
  end
end
