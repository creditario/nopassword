require "test_helper"

module NoPassword
  class Concerns::ControllerHelpersTest < ActionDispatch::IntegrationTest

    test "it checks for a current_session" do
      session = no_password_sessions(:session_claimed)

      session_cookie = NoPassword::ControllerHelpersTestController.new(:index) { sign_in }
      session_cookie.sign_in(session)

      refute_nil session_cookie
    end
  end

  class ControllerHelpersTestController < ActionController::Base
    include Concerns::ControllerHelpers
    helper_method :current_session, :signed_in_session?, :sign_in, :sign_out

    def initialize(method_name, &method_body)
      self.class.send(:define_method, method_name, method_body)
    end
  end
end