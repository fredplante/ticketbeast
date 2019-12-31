require "test_helper"

class ViewOrderTest < ActionDispatch::IntegrationTest
  test "user can view their order confirmation" do
    concert = create(:concert)
    order = create(:order, confirmation_number: "ORDERCONFIRMATION1234")
    ticket = create(:ticket, concert: concert, order: order)

    get "/orders/ORDERCONFIRMATION1234"

    assert_response :ok
  end
end
