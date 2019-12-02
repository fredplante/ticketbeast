class ConcertPresenterTest < ActionView::TestCase
  test "can get formatted date" do
    concert = build(:concert, date: Time.zone.parse("2016-12-01 8:00pm"))
    concert_presenter = ConcertPresenter.new(concert, view)

    assert_equal "December 1, 2016", concert_presenter.formatted_date
  end

  test "can get formatted start time" do
    concert = build(:concert, date: Time.zone.parse("2016-12-01 17:00:00"))
    concert_presenter = ConcertPresenter.new(concert, view)

    assert_equal "5:00pm", concert_presenter.formatted_start_time
  end

  test "can get ticket price in dollars" do
    concert = build(:concert, ticket_price: 6750)
    concert_presenter = ConcertPresenter.new(concert, view)

    assert_equal "67.50", concert_presenter.ticket_price_in_dollars
  end
end
