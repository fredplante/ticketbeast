class ConcertPresenter < BasePresenter
  presents :concert

  delegate :id, :title, :subtitle, :venue, :venue_address, :city, :state,
           :zip, :additional_information, :ticket_price, to: :concert

  def formatted_date
    concert.date.strftime("%B %-d, %Y")
  end

  def formatted_start_time
    concert.date.strftime("%-l:%M%P")
  end

  def ticket_price_in_dollars
    number_with_precision(concert.ticket_price.to_f / 100, precision: 2)
  end
end
