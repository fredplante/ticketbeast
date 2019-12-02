FactoryBot.define do
  factory :concert do
    title { "Example Band" }
    subtitle { "with the Fake Openers" }
    date { 2.weeks.from_now }
    ticket_price { 2000 }
    venue { "The Example Theatre" }
    venue_address { "123 Example Lane" }
    city { "Fakeville" }
    state { "ON" }
    zip { "90210" }
    additional_information { "For tickets, call (555) 555-5555" }

    trait :published do
      published_at { 1.week.ago }
    end

    trait :unpublished do
      published_at { nil }
    end
  end
end
