require "test_helper"

module NoPassword
  class SessionTest < ActiveSupport::TestCase
    test "is valid" do
      subject = Session.new(model_params)

      assert subject.valid?
    end

    test "is invalid without token" do
      subject = Session.new(model_params({token: nil}))

      refute subject.valid?
      assert_equal 1, subject.errors.count
    end

    private

    def model_params(attrs = {})
      {
        token: "NnqE-5854-NUQC",
        user_agent: "Chrome/95.0.4214.45",
        remote_addr: "95.0.4214.45",
        return_url: "https://www.creditario.io/home",
        email: "test@example.com"
      }.merge(attrs)
    end
  end
end
