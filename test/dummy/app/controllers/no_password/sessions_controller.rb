# frozen_string_literal: true

load NoPassword::Engine.root.join("app", "controllers", "no_password", "sessions_controller.rb")
NoPassword::SessionsController.class_eval do
  layout "application"
end
