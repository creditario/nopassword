require "test_helper"
require "uri"

module NoPassword
  class SessionsControllerTest < ActionDispatch::IntegrationTest
    def setup
      @sample = SessionsController.new
      @sample.set_request!(ActionDispatch::TestRequest.create({}))
      @sample.set_response!(SessionsController.make_response!(@sample.request))
    end

    test "it gets passwordless login" do
      session = no_password_sessions(:session_claimed)
      
      post no_password.sessions_path, params: {email: session.email}

    #   @sample.stub :session, {} do
    #     URI(@sample.request.referer).path == "/p"
        
    #     assert @sample.sign_in(session)
    #   end

      assert_redirect_to no_password.edit_session_confirmations_path
      assert_response :success
    end
  end
end
