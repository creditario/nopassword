class HomeController < ApplicationController
  include Authenticate
  before_action :authenticate_session, only: [:show]

  def index
  end

  def show
  end
end
