FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "project#{n}" }
    export true

    trait :private do
      export false
    end
  end
end
