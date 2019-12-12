FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "john-doe#{n}@test.test"
    end
  end
end