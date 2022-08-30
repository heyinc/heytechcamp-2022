require "test_helper"

class SalesChannelsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get sales_channels_show_url
    assert_response :success
  end

  test "should get index" do
    get sales_channels_index_url
    assert_response :success
  end
end
