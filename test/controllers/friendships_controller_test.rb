require "test_helper"

class FriendshipsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get friendships_new_url
    assert_response :success
  end

  test "should get create" do
    get friendships_create_url
    assert_response :success
  end

  test "should get update" do
    get friendships_update_url
    assert_response :success
  end

  test "should get show" do
    get friendships_show_url
    assert_response :success
  end
end
