require "test_helper"

module NoPassword
  class ControllerHelpersTest < ActionDispatch::IntegrationTest
    test "it checks for current session when logging in" do
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}
      patch no_password.session_confirmations_path(token: NoPassword::Session.last.token)

      assert @controller.current_session
    end

    test "it checks if signed_in_session is true when logging in" do
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}
      patch no_password.session_confirmations_path(token: NoPassword::Session.last.token)

      assert @controller.signed_in_session?
    end

    test "it checks there is no current session if failed to log in" do
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}
      patch no_password.session_confirmations_path(token: "Invalid-Token")

      assert_nil @controller.current_session
    end

    test "it checks if signed_in_session is false when failed to log in" do
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}
      patch no_password.session_confirmations_path(token: "Invalid-Token")

      refute @controller.signed_in_session?
    end

    test "it checks 'authenticate_session!' functionality, it can't access to main_app.home_path if signed_in_session? is false" do
      get "/home/1"

      refute @controller.signed_in_session?
      assert_redirected_to no_password.new_session_path
    end
  end
end
