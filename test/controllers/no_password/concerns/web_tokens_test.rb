require "test_helper"

module NoPassword
  class WebTokensTest < ActionDispatch::IntegrationTest
    def setup
      @sample = SampleController.new
    end

    test "it verifies if original token remains the same after been signed" do
      session = no_password_sessions(:session_one)

      signed_token = @sample.token_to_url(@sample.sign_token(session.token))
      token_from_url = @sample.token_from_url(signed_token)
      verified_token = @sample.verify_token(token_from_url)

      assert_equal session.token, verified_token
    end
  end

  # Controlador para pruebas del Concern SignTokens
  class SampleController < ActionController::Base
    include Concerns::WebTokens
  end
end
