# typed: ignore
# frozen_string_literal: true

require "active_support/concern"

module Authenticate
  extend ActiveSupport::Concern
  include NoPassword::Concerns::ControllerHelpers

  included do
    def authenticate_session
      unless signed_in_session?
        session[:referrer_path] = request.fullpath
        redirect_to no_password.new_session_path, alert: t("flash.update.session.alert")
      end
    end
  end
end
