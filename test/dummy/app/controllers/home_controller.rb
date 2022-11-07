# frozen_string_literal: true

class HomeController < ApplicationController
  include NoPassword::ControllerHelpers
  before_action :authenticate_session!, only: [:show]

  def index
  end

  def show
  end
end
