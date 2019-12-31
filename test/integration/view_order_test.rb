require "test_helper"

class ViewOrderTest < ActionDispatch::IntegrationTest
  test "user can view their order confirmation" do
    concert = create(:concert)
    order = create(:order)
    ticket = create(:ticket, concert: concert, order: order)

  end
end
