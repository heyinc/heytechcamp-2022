require "test_helper"

class CustomersControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get customers_show_url
    assert_response :success
  end

  test "should get index" do
    get customers_index_url
    assert_response :success
  end
end
