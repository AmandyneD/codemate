require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get projects" do
    get dashboard_projects_url
    assert_response :success
  end
end
