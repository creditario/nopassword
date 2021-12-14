# frozen_string_literal: true

require "uri"

module NoPassword
  class SessionsController < ApplicationController
    before_action :setup_referrer_path, only: [:new]

    def new
      @resource = Session.new
    end

    def create
      user_agent = request.user_agent
      email = params.dig(:session, :email)
      remote_addr = request.remote_ip
      return_url = session[:referrer_path]

      session = SessionManager.new

      session.create(user_agent, email, remote_addr, return_url)
    end

    private

    def setup_referrer_path
      session[:referrer_path] = validate_referrer_path
    end

    def validate_referrer_path
      referrer_path = URI(request.referer).path if request.referer.present?
      return nil unless referrer_path

      if self_path?(referrer_path) || external_path?(referrer_path)
        nil
      else
        referrer_path
      end
    end

    def self_path?(referrer_path)
      referrer_path == no_password.new_session_path
    end

    def external_path?(referrer_path)
      referrer_path[1] != "p"
    end
  end
end
