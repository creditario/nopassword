# typed: ignore
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

        def sign_in(session_model, key = nil, data = nil)
          if session_model.claimed? && !session_model.expired?
            session[session_key] = session_model.id

            if key.present? && data.present?
              session[session_key(key)] = data
            end
            session_model
          end
        end

        def sign_out(key = nil)
          session.delete(session_key)
          session.delete(session_key(key)) if key.present?
          @session = nil
          true
        end

        helper_method :current_session, :signed_in_session?, :sign_in, :sign_out

        protected

        def session_key(value = "id")
          "—-no_password_session_#{value}"
        end
      end
    end
  end
end
