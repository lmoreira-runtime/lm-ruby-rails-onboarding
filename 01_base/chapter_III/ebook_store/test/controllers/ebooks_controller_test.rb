require "test_helper"

class EbooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @ebook = ebooks(:one)
  end

  test "should get index" do
    get ebooks_url
    assert_response :success
  end

  test "should get new" do
    get new_ebook_url
    assert_response :success
  end

  test "should create ebook" do
    assert_difference("Ebook.count") do
      post ebooks_url, params: { ebook: { description: @ebook.description, price: @ebook.price, status: @ebook.status, title: @ebook.title, user_id: @ebook.user_id } }
    end

    assert_redirected_to ebook_url(Ebook.last)
  end

  test "should show ebook" do
    get ebook_url(@ebook)
    assert_response :success
  end

  test "should get edit" do
    get edit_ebook_url(@ebook)
    assert_response :success
  end

  test "should update ebook" do
    patch ebook_url(@ebook), params: { ebook: { description: @ebook.description, price: @ebook.price, status: @ebook.status, title: @ebook.title, user_id: @ebook.user_id } }
    assert_redirected_to ebook_url(@ebook)
  end

  test "should destroy ebook" do
    assert_difference("Ebook.count", -1) do
      delete ebook_url(@ebook)
    end

    assert_redirected_to ebooks_url
  end
end
