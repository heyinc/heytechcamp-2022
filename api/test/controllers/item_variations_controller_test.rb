require "test_helper"

class ItemVariationsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get item_variations_show_url
    assert_response :success
  end

  test "should get index" do
    get item_variations_index_url
    assert_response :success
  end
end
