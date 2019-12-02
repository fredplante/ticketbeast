class ConcertPresenter < BasePresenter
  presents :concert

  def formatted_date
    concert.date.strftime("%B %-d, %Y")
  end

end
