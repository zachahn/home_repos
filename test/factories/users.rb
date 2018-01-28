FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "hello#{n}@example.com"
    end
    password "password"
    expires_at nil
    admin false

    trait :admin do
      admin true
    end
  end
end
