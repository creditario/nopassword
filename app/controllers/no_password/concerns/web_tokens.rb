# typed: ignore
# frozen_string_literal: true

require "active_support/concern"

module NoPassword
  module Concerns
    module WebTokens
      extend ActiveSupport::Concern

      included do
        def sign_token(data, expires_in: NoPassword.configuration.session_expiration)
          secret_key = NoPassword.configuration.secret_key || Rails.application.secret_key_base
          verifier = ActiveSupport::MessageVerifier.new(secret_key)
          verifier.generate(data, expires_in: expires_in, purpose: :no_password_login)
        end

        def verify_token(data)
          secret_key = NoPassword.configuration.secret_key || Rails.application.secret_key_base
          verifier = ActiveSupport::MessageVerifier.new(secret_key)

          token = token_from_url(data)
          verifier.verified(token, purpose: :no_password_login)
        end

        def token_to_url(token)
          CGI.escape(token)
        end

        def token_from_url(token)
          CGI.unescape(token)
        end
      end
    end
  end
end
