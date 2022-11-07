# frozen_string_literal: true

require "test_helper"

class CustomSessionConfirmationsController < NoPassword::SessionConfirmationsController
  def after_sign_in!(signed_in, by_url, return_url)
    # Do something else
    redirect_to main_app.root_path
  end
end

module NoPassword
  class SessionConfirmationsControllerTest < ActionDispatch::IntegrationTest
    include PrintRoutes
    include NoPassword::WebTokens

    def teardown
      Rails.application.routes.prepend.clear
      Rails.application.reload_routes!
    end

    test "it redirects to return_url after signin with magic link" do
      session = no_password_sessions(:session_unclaimed)
      signed_token = token_to_url(sign_token(session.token))

      get no_password.session_confirmation_path(token: signed_token)

      assert_redirected_to session.return_url
    end

    test "it redirects to root if after signin with magic link and no return_url" do
      session = no_password_sessions(:session_unclaimed)
      session.update(return_url: nil)
      signed_token = token_to_url(sign_token(session.token))

      get no_password.session_confirmation_path(token: signed_token)

      assert_redirected_to "/"
    end

    test "it shows error notification with invalid magic link" do
      get no_password.session_confirmation_path(token: "invalid_token")

      assert_response :success
      assert_equal I18n.t("flash.update.invalid_code.alert"), flash[:alert]
    end

    test "it shows error notification with expired magic link" do
      session = no_password_sessions(:session_unclaimed)
      signed_token = token_to_url(sign_token(session.token))

      travel_to Time.zone.now.advance(minutes: 16.minutes) do
        get no_password.session_confirmation_path(token: signed_token)

        assert_response :success
        assert_equal I18n.t("flash.update.invalid_code.alert"), flash[:alert]
      end
    end

    test "it shows error notification with claimed magic link" do
      session = no_password_sessions(:session_unclaimed)
      session.update(claimed_at: Time.zone.now)
      signed_token = token_to_url(sign_token(session.token))

      travel_to Time.zone.now.advance(minutes: 16.minutes) do
        get no_password.session_confirmation_path(token: signed_token)

        assert_response :success
        assert_equal I18n.t("flash.update.invalid_code.alert"), flash[:alert]
      end
    end

    test "it redirects to return_url after singin with a token" do
      session = no_password_sessions(:session_unclaimed)

      patch no_password.session_confirmations_path(token: session.token)

      assert_redirected_to session.return_url
    end

    test "it redirects to root after signin with a token and no return_url" do
      session = no_password_sessions(:session_unclaimed)
      session.update(return_url: nil)

      patch no_password.session_confirmations_path(token: session.token)

      assert_redirected_to "/"
    end

    test "it shows error notification with expired session" do
      session = no_password_sessions(:session_unclaimed)

      travel_to Time.zone.now.advance(minutes: 161.minutes) do
        patch no_password.session_confirmations_path(token: session.token)
      end

      assert_turbo_stream status: :unprocessable_entity, action: :update, target: "notifications" do |frame|
        assert_match flash.alert[:description], frame.children.to_html
      end
    end

    test "it shows error notification with claimed token" do
      session = no_password_sessions(:session_claimed)

      patch no_password.session_confirmations_path(token: session.token)

      assert_turbo_stream status: :unprocessable_entity, action: :update, target: "notifications" do |frame|
        assert_match flash.alert[:description], frame.children.to_html
      end
    end

    test "it shows error notification with invalid token" do
      patch no_password.session_confirmations_path(token: "invalid_token")

      assert_turbo_stream status: :unprocessable_entity, action: :update, target: "notifications" do |frame|
        assert_match flash.alert[:description], frame.children.to_html
      end
    end

    test "it responds via after_sign_in hook when session is not valid via magic link" do
      Rails.application.routes.prepend do
        get "/confirmations/:token", to: "custom_session_confirmations#edit", as: :custom_confirmation_link
      end
      Rails.application.reload_routes!

      get custom_confirmation_link_path(token: "invalid-token")

      refute_nil flash[:alert]
      assert_redirected_to main_app.root_path
    end

    test "it responds via after_sign_in hook when session is valid via magic link" do
      Rails.application.routes.prepend do
        get "/confirmations/:token", to: "custom_session_confirmations#edit", as: :custom_confirmation_link
      end
      Rails.application.reload_routes!

      session = no_password_sessions(:session_unclaimed)
      signed_token = token_to_url(sign_token(session.token))

      get custom_confirmation_link_path(token: signed_token)

      assert_nil flash[:alert]
      assert_redirected_to main_app.root_path
    end
  end
end
