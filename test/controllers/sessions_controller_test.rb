require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def test_log_in_valid_user
    user = FactoryBot.create(:user, email: "hi@example.com", password: "hello")

    post(session_url, params: { email: "hi@example.com", password: "hello" })

    assert_equal(user.id, controller.session[:user_id])
  end

  def test_log_in_invalid_user
    post(session_url, params: { email: "dne@example.com", password: "hello" })

    assert_nil(controller.session[:user_id])
  end

  def test_log_out
    FactoryBot.create(:user, email: "hi@example.com", password: "hello")

    post(session_url, params: { email: "hi@example.com", password: "hello" })
    delete(session_url)

    assert_nil(controller.session[:user_id])
  end
end
