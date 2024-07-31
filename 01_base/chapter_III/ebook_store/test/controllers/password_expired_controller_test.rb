require "test_helper"

class PasswordExpiredControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get password_expired_edit_url
    assert_response :success
  end

  test "should get update" do
    get password_expired_update_url
    assert_response :success
  end
end
