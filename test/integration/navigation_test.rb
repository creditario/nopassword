require "test_helper"

class NavigationTest < ActionDispatch::IntegrationTest
  test "It redirects to no_password.new_session_path if no session is currently active" do
    get "/home/1"

    assert_redirected_to no_password.new_session_path
  end

  test "It shows No active session title on Home#index if no session is currently active" do
    get "/"

    assert_select "#session_status", "No active session"
  end

  test "It shows current_session email as title on Home#index if a session currently active" do
    post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}
    patch no_password.session_confirmations_path(token: NoPassword::Session.last.token)
    get "/"

    assert_select "#session_status", @controller.current_session.email
  end

  test "It gets Home#show if a session is currently active" do
    post no_password.sessions_path, params: {session: {email: "ana@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}
    patch no_password.session_confirmations_path(token: NoPassword::Session.last.token)
    get "/home/1"

    assert_select "#session_status", @controller.current_session.email
    assert_response :success
  end
end
