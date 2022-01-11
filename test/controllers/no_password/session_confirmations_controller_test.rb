require "test_helper"

module NoPassword
  class SessionConfirmationsControllerTest < ActionDispatch::IntegrationTest
    include Concerns::WebTokens

    test "it redirects to return_url if token is valid after using magic link" do
      session = no_password_sessions(:session_one)
      signed_token = token_to_url(sign_token(session.token))

      get no_password.session_confirmation_path(token: signed_token)

      assert_redirected_to session.return_url
    end

    test "it shows error notification if token is invalid after using magic link" do
      get no_password.session_confirmation_path(token: "invalid_token")

      assert_equal I18n.t("flash.update.invalid_code.alert"), flash[:alert]
    end

    test "it redirects to root if token is valid and return_url is nil after using magic link" do
      session = no_password_sessions(:session_one)
      session.update(return_url: nil)
      signed_token = token_to_url(sign_token(session.token))
      main_app_root_path = main_app.root_path

      get no_password.session_confirmation_path(token: signed_token)

      assert_redirected_to main_app_root_path
    end

    test "it redirects to return_url if token is valid after using friendly token" do
      session = no_password_sessions(:session_one)

      patch no_password.session_confirmations_path(token: session.token)

      assert_redirected_to session.return_url
    end

    test "it redirects to root if token is valid after using friendly token" do
      session = no_password_sessions(:session_one)
      session.update(return_url: nil)
      main_app_root_path = main_app.root_path

      patch no_password.session_confirmations_path(token: session.token)

      assert_redirected_to main_app_root_path
    end

    test "it flashes an error notification if token is already claimed" do
      session = no_password_sessions(:session_claimed)

      patch no_password.session_confirmations_path(token: session.token)

      assert_turbo_stream status: :unprocessable_entity, action: :update, target: "notifications" do |frame|
        assert_match flash.alert[:description], frame.children.to_html
      end
    end

    test "it flashes an error notification if token is already expired" do
      session = no_password_sessions(:session_one)
      passed_minutes = NoPassword.configuration.session_expiration + 10

      travel passed_minutes.minutes do
        patch no_password.session_confirmations_path(token: session.token)
      end

      assert_turbo_stream status: :unprocessable_entity, action: :update, target: "notifications" do |frame|
        assert_match flash.alert[:description], frame.children.to_html
      end
    end

    test "it shows error notification if token doesn't exist" do
      patch no_password.session_confirmations_path(token: "invalid_token"), as: :turbo_stream

      assert_turbo_stream status: :unprocessable_entity, action: :update, target: "notifications" do |frame|
        assert_match flash.alert[:description], frame.children.to_html
      end
    end
  end
end
