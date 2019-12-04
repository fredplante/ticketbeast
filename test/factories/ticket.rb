FactoryBot.define do
  factory :ticket do
    concert

    trait :reserved do
      reserved_at { Time.current }
    end
  end
end
