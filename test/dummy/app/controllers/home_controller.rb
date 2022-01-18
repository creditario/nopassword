class HomeController < ApplicationController
  include NoPassword::Concerns::ControllerHelpers
  before_action :authenticate_session!, only: [:show]

  def index
  end

  def show
  end
end
