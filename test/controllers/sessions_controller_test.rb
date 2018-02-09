require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def test_log_in_valid_user
    user = FactoryBot.create(:user, email: "hi@example.com", password: "hello")

    login_as(user)

    assert_equal(user.id, controller.session[:user_id])
  end

  def test_log_in_invalid_user
    fake_user = OpenStruct.new(email: "dne@example.com", password: "hello")

    login_as(fake_user)

    assert_nil(controller.session[:user_id])
  end

  def test_log_out
    user = FactoryBot.create(:user, email: "hi@example.com", password: "hello")

    login_as(user)
    delete(session_url)

    assert_nil(controller.session[:user_id])
  end

  def test_log_in_with_token
    user = FactoryBot.create(:user, email: "hi@example.com", password: "hello")
    token = FactoryBot.create(:access_token, user: user, password: "!key!")

    token_login_as(user, token)

    assert_equal(user.id, controller.session[:user_id])
  end
end
