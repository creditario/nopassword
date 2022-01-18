require "test_helper"

module NoPassword
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test "referer_path is nil if HTTP_REFERER is originated from engine's new_session_path" do
      get no_password.new_session_path, headers: {HTTP_REFERER: no_password.new_session_url}

      assert_nil session[:referrer_path]
    end

    test "referer_path is present if HTTP_REFERER is originated from a internal url" do
      get no_password.new_session_path, headers: {HTTP_REFERER: no_password.sessions_url}

      assert session[:referrer_path]
    end

    test "it creates a session with nil referer_path if HTTP_REFERER is originated from engine's new_session_path" do
      get no_password.new_session_path, headers: {HTTP_REFERER: no_password.new_session_url}
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}

      assert_nil NoPassword::Session.last.return_url
    end

    test "it creates a session with nil referer_path if HTTP_REFERER is originated from engine's edit_session_confirmations_path" do
      get no_password.new_session_path, headers: {HTTP_REFERER: no_password.edit_session_confirmations_path}
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}

      assert_nil NoPassword::Session.last.return_url
    end

    test "it creates a session with referer_path if HTTP_REFERER is originated from an internal url" do
      get no_password.new_session_path, headers: {HTTP_REFERER: no_password.sessions_url}
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}

      assert NoPassword::Session.last.return_url
    end

    test "it redirects to redirect_to no_password.edit_session_confirmations_path if current_session.present?" do
      get no_password.new_session_path, headers: {HTTP_REFERER: no_password.sessions_url}
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}

      assert_redirected_to no_password.edit_session_confirmations_path
    end

    test "it destroys a session and redirects to main_app.root_path" do
      get no_password.new_session_path, headers: {HTTP_REFERER: no_password.new_session_url}
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}
      patch no_password.session_confirmations_path(token: NoPassword::Session.last.token)

      delete no_password.session_path(session["—-no_password_session_id"])

      assert_nil session["—-no_password_session_id"]
      assert_redirected_to "/"
    end
  end
end
