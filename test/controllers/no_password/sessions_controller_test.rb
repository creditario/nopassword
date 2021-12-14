require "test_helper"
require "uri"

module NoPassword
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    test "referer_path is nil if HTTP_REFERER is originated from a external url" do
      get no_password.new_session_path, headers: {"HTTP_REFERER" => "http://test.com/external"}

      assert_nil session[:referrer_path]
    end

    test "referer_path is nil if HTTP_REFERER is originated from engine's new_session_path" do
      get no_password.new_session_path, headers: {"HTTP_REFERER" => "http://test.com/p/sessions/new"}

      assert_nil session[:referrer_path]
    end

    test "referer_path is present if HTTP_REFERER is originated from a internal url" do
      get no_password.new_session_path, headers: {"HTTP_REFERER" => "http://test.com/p/internal_url"}

      assert session[:referrer_path]
    end

    test "it creates a session with nil referer_path if HTTP_REFERER is originated from external url" do
      get no_password.new_session_path, headers: {"HTTP_REFERER" => "http://test.com/external"}
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {"HTTP_USER_AGENT" => "Mozilla/5.0"}

      assert_nil NoPassword::Session.last.return_url
    end

    test "it creates a session with nil referer_path if HTTP_REFERER is originated from engine's new_session_path" do
      get no_password.new_session_path, headers: {"HTTP_REFERER" => "http://test.com/p/sessions/new"}
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {"HTTP_USER_AGENT" => "Mozilla/5.0"}

      assert_nil NoPassword::Session.last.return_url
    end

    test "it creates a session with referer_path if HTTP_REFERER is originated from an internal url" do
      get no_password.new_session_path, headers: {"HTTP_REFERER" => "http://test.com/p/internal_url"}
      post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {"HTTP_USER_AGENT" => "Mozilla/5.0"}

      assert NoPassword::Session.last.return_url
    end
  end
end
