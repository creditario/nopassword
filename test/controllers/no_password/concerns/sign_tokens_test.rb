require "test_helper"

module NoPassword
  class SignTokensTest < ActionDispatch::IntegrationTest
    def setup
      @sample = SampleController.new
    end

    test "it verifies if original token remains the same after been signed" do
      session = no_password_sessions(:session_one)
      original_token = session.token
      session.update(token: @sample.sign_token(session.token))

      signed_token = @sample.verify_signed_token(session.token)

      assert_equal original_token, signed_token
    end

    test "it compares original token and token from url" do
      session = no_password_sessions(:session_one)
      token_to_url = @sample.token_to_url(session.token)

      token_from_url = @sample.token_from_url(token_to_url)

      assert_equal session.token, token_from_url
    end
  end

  # Controlador para pruebas del Concern SignTokens
  class SampleController < ActionController::Base
    include Concerns::SignTokens
  end
end
