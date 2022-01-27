# frozen_string_literal: true

require "active_support/concern"

module NoPassword
  module Concerns
    module ControllerHelpers
      extend ActiveSupport::Concern

      included do
        def current_session
          session_id = session[session_key]
          @session ||= NoPassword::Session.find_by_id(session_id)
        end

        def signed_in_session?
          current_session.present?
        end

        def authenticate_session!
          unless signed_in_session?
            session[:referrer_path] = request.fullpath
            redirect_to no_password.new_session_path, alert: t("flash.update.session.alert")
          end
        end

        helper_method :current_session, :signed_in_session?

        protected

        def session_key(value = "id")
          "—-no_password_session_#{value}"
        end
      end
    end
  end
end
