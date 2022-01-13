require "test_helper"
require "minitest/mock"

module NoPassword
  class ControllerHelpersTest < ActionDispatch::IntegrationTest
    def setup
      @sample = SampleController.new
      @sample.set_request!(ActionDispatch::TestRequest.create({}))
      @sample.set_response!(SampleController.make_response!(@sample.request))
    end

    test "it checks if signs in successfully" do
      session = no_password_sessions(:session_claimed)

      @sample.stub :session, {} do
        assert @sample.sign_in(session)
      end
    end

    test "it fails to sign in" do
      session = no_password_sessions(:session_one)

      @sample.stub :session, {} do
        assert_nil @sample.sign_in(session)
      end
    end

    test "checks for current session" do
      session = no_password_sessions(:session_claimed)

      @sample.stub :session, {} do
        new_sign_in = @sample.sign_in(session)

        assert_equal @sample.current_session, new_sign_in
      end
    end

    test "checks for signed in session boolean" do
      session = no_password_sessions(:session_claimed)

      @sample.stub :session, {} do
        @sample.sign_in(session)

        assert @sample.signed_in_session?
      end
    end
  end

  # Controlador para pruebas del Concern ControllerHelpers
  class SampleController < ActionController::Base
    include Concerns::ControllerHelpers
  end
end
