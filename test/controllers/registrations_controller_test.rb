require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get sign_up_url
    assert_response :success
  end

  test "should sign up" do
    assert_difference("User.count") do
      post sign_up_url, params: { username: "noxinorazal", password: "Secret1*3*5*", password_confirmation: "Secret1*3*5*", gender: users(:lazaro_nixon).gender, birthdate: users(:lazaro_nixon).birthdate }
    end

    assert_redirected_to root_url
  end
end
