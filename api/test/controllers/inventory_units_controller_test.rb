require "test_helper"

class InventoryUnitsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get inventory_units_show_url
    assert_response :success
  end

  test "should get index" do
    get inventory_units_index_url
    assert_response :success
  end
end
