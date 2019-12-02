class ConcertPresenterTest < ActionView::TestCase
  test "can get formatted date" do
    concert = build(:concert, date: Time.zone.parse("2016-12-01 8:00pm"))
    concert_presenter = ConcertPresenter.new(concert, view)

    date = concert_presenter.formatted_date

    assert_equal "December 1, 2016", date
  end
end
