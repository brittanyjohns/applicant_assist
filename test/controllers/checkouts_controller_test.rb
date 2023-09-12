require "test_helper"

class CheckoutsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get checkouts_new_url
    assert_response :success
  end

  test "should get show" do
    get checkouts_show_url
    assert_response :success
  end
end
