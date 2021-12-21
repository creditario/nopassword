# typed: ignore
# frozen_string_literal: true

require "active_support/concern"

module NoPassword
  module Concerns
    module WebTokens
      extend ActiveSupport::Concern

      @token_expiration = Time.zone.now.advance(minutes: NoPassword.configuration.session_expiration)

      included do
        def sign_token(data, expires_in: @token_expiration)
          generate_token(data, expires_in: expires_in, purpose: :no_password_login)
        end

        def verify_token(data)
          verify_url_token(data, purpose: :no_password_login)
        end

        def token_to_url(token)
          CGI.escape(token)
        end

        def token_from_url(token)
          CGI.unescape(token)
        end

        private

        def verify_url_token(data, purpose: nil)
          secret_key = NoPassword.configuration.secret_key || Rails.application.secret_key_base
          verifier = ActiveSupport::MessageVerifier.new(secret_key)

          token = token_from_url(data)
          verifier.verified(token, purpose: purpose)
        end

        def generate_token(data, expires_in: @token_expiration, purpose: nil)
          secret_key = NoPassword.configuration.secret_key || Rails.application.secret_key_base
          verifier = ActiveSupport::MessageVerifier.new(secret_key)
          verifier.generate(data, expires_in: expires_in, purpose: purpose)
        end
      end
    end
  end
end
