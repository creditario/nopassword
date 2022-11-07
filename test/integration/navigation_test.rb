# frozen_string_literal: true

require "test_helper"

class NavigationTest < ActionDispatch::IntegrationTest
  test "it redirects to start new session" do
    path = main_app.secure_area_path
    get path

    assert_redirected_to no_password.new_session_path(return_to: CGI.escape(path))
  end

  test "it shows no active session" do
    get main_app.root_path

    assert_select "#session_status", "No session"
  end

  test "it shows active session" do
    post no_password.session_path, params: {session: {email: "test@example.com"}}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}
    patch no_password.session_confirmations_path(token: NoPassword::Session.last.token)

    follow_redirect!

    assert_response :success
    assert_select "#session_status", @controller.current_session.email
  end

  test "it access secure area" do
    post no_password.session_path, params: {session: {email: "test@example.com"}, return_to: main_app.secure_area_path}, headers: {HTTP_USER_AGENT: "Mozilla/5.0"}
    patch no_password.session_confirmations_path(token: NoPassword::Session.last.token)

    assert_redirected_to "/show"
    follow_redirect!

    assert_select "#session_status", @controller.current_session.email
  end
end
