require "test_helper"

class UserTechnologiesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get user_technologies_create_url
    assert_response :success
  end

  test "should get destroy" do
    get user_technologies_destroy_url
    assert_response :success
  end
end
