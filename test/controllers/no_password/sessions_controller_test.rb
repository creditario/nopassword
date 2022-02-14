# frozen_string_literal: true

require "test_helper"

module NoPassword
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test "it creates a session with nil referer_path if return_to path is engine's new_session_path" do
      get no_password.new_session_url
      post no_password.sessions_path(return_to: CGI.escape(request.fullpath)), params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}

      assert_nil NoPassword::Session.last.return_url
    end

    test "it creates a session with nil referer_path if return_to path is engine's edit_session_confirmations_path" do
      get no_password.edit_session_confirmations_path
      post no_password.sessions_path(return_to: CGI.escape(request.fullpath)), params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}

      assert_nil NoPassword::Session.last.return_url
    end

    test "it creates a session with referer_path if return_to path is an internal url" do
      path = "/home/1"
      get path
      post no_password.sessions_path(return_to: CGI.escape(path)), params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}

      assert NoPassword::Session.last.return_url
    end

    test "it redirects to no_password.edit_session_confirmations_path after send form with email" do
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}

      assert_redirected_to no_password.edit_session_confirmations_path
    end

    test "it destroys a session and redirects to main_app.root_path" do
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}
      patch no_password.session_confirmations_path(token: NoPassword::Session.last.token)

      delete no_password.session_path(session["—-no_password_session_id"])

      assert_nil session["—-no_password_session_id"]
      assert_redirected_to "/"
    end
  end
end
