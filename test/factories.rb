FactoryGirl.define do
  factory :user do
    sequence(:name)  { |i| "testuser#{i}" }
    sequence(:email) { |i| "testuser#{i}@email.com" }
    password              '123456'
    password_confirmation '123456'
  end

  factory :short_url do
    original_url 'http://www.google.com'
  end
end
