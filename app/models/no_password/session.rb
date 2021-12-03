# frozen_string_literal: true

module NoPassword
  class Session < ApplicationRecord
    validates :token, :user_agent, :remote_addr, :email, presence: true
  end
end
