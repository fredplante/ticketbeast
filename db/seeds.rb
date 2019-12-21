concert = FactoryBot.create(:concert, :published,
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
)

concert.add_tickets(10)
