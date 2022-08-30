require "test_helper"

class CustomerAddressesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get customer_addresses_show_url
    assert_response :success
  end

  test "should get index" do
    get customer_addresses_index_url
    assert_response :success
  end
end
