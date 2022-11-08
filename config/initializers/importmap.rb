# frozen_string_literal: true

require "no_password"

NoPassword.configuration.importmap.draw do
  # Stimulus & Turbo
  pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
  pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
  pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
  pin "stimulus-use", to: "https://ga.jspm.io/npm:stimulus-use@0.50.0-2/dist/index.js"
  pin "hotkeys-js", to: "https://ga.jspm.io/npm:hotkeys-js@3.8.7/dist/hotkeys.esm.js"

  # NoPassword entrypoint
  pin "application", to: "no_password/application.js", preload: true

  pin_all_from NoPassword::Engine.root.join("app/assets/javascripts/no_password/controllers"), under: "controllers", to: "no_password/controllers"
end
