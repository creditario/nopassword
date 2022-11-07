# frozen_string_literal: true

module NoPassword
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      def current_session
        @session ||= begin
          session_id = session[session_key]
          return nil if session_id.blank?

          current_session = find_session(session_id)
          session[session_key] = nil if current_session.blank?

          current_session
        end
      end

      def signed_in_session?
        current_session.present?
      end

      def authenticate_session!
        redirect_to no_password.new_session_path(return_to: CGI.escape(request.fullpath)), alert: t("flash.update.session.alert") unless signed_in_session?
      end

      helper_method :current_session, :signed_in_session?

      protected

      def session_key(value = "id")
        "—-no_password_session_#{value}"
      end

      private

      def find_session(session_id)
        NoPassword::Session.where.not(claimed_at: nil)
          .where("expires_at > ?", Time.zone.now)
          .find_by_id(session_id)
      end
    end
  end
end
