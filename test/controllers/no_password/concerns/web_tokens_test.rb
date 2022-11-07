require "test_helper"

module NoPassword
  class WebTokensTest < ActionDispatch::IntegrationTest
    def setup
      @sample ||= SampleController.new
    end

    test "it verifies token" do
      session = no_password_sessions(:session_unclaimed)

      signed_token = @sample.sign_token(session.token)
      verified_token = @sample.verify_token(signed_token)

      assert_equal session.token, verified_token
    end

    test "it verifies encoded token" do
      session = no_password_sessions(:session_unclaimed)

      signed_token = @sample.sign_token(session.token)
      encoded_token = @sample.token_to_url(signed_token)

      decoded_token = @sample.token_from_url(encoded_token)
      verified_token = @sample.verify_token(decoded_token)

      assert_equal session.token, verified_token
    end

    test "it fails to verify token" do
      signed_token = "invalid_token"
      verified_token = @sample.verify_token(signed_token)

      assert_nil verified_token
    end

    test "it fails to verify expired token" do
      session = no_password_sessions(:session_unclaimed)

      signed_token = @sample.sign_token(session.token)
      # By default sign in tokens expires after 15 minutes
      travel_to Time.zone.now.advance(minutes: 16.minutes) do
        verified_token = @sample.verify_token(signed_token)

        assert_nil verified_token
      end
    end
  end

  class SampleController < ActionController::Base
    include NoPassword::WebTokens
  end
end
