require "test_helper"

class CollaborationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get collaborations_create_url
    assert_response :success
  end

  test "should get index" do
    get collaborations_index_url
    assert_response :success
  end

  test "should get update" do
    get collaborations_update_url
    assert_response :success
  end
end
