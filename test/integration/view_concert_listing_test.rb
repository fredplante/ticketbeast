require "test_helper"

class ViewConcertListingTest < ActionDispatch::IntegrationTest
  test "user can view a published concert listing" do
    concert = Concert.create(
    	title: "The Red Chord",
    	subtitle: "with Animosity and Lethargy",
    	date: Time.zone.parse("December 13, 2016 8:00pm"),
    	ticket_price: 3250,
    	venue: "The Mosh Pit",
    	venue_address: "123 Example Lane",
    	city: "Laraville",
    	state: "ON",
    	zip: "17916",
    	additional_information: "For tickets, call (555) 555-5555",
      published_at: 1.week.ago
    )

    get "/concerts/#{concert.id}"

    assert_match "The Red Chord", response.body
    assert_match "with Animosity and Lethargy", response.body
    assert_match "December 13, 2016", response.body
    assert_match "8:00pm", response.body
    assert_match "32.50", response.body
    assert_match "The Mosh Pit", response.body
    assert_match "123 Example Lane", response.body
    assert_match "Laraville, ON 17916", response.body
    assert_match "For tickets, call (555) 555-5555", response.body
  end

  test "user cannot view unpublished concert listings" do
    concert = create(:concert, published_at: nil)

    get "/concerts/#{concert.id}"

    assert_response :not_found
  end

end
