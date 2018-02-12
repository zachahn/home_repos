FactoryBot.define do
  factory :project do
    sequence(:name) { |n| "project#{n}" }
    backup_name { SecureRandom.uuid }
    export true

    trait :private do
      export false
    end
  end
end
