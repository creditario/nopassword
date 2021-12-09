module NoPassword
  class ApplicationController < ActionController::Base
    helper_method :current_session, :signed_in_session?, :sign_in, :sign_out
  end
end
