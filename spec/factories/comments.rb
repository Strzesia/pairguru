FactoryBot.define do
  factory :comment do
    text "MyText"
    user :user
    movie :movie
  end
end
