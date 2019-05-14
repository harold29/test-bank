FactoryBot.define do
  factory :account do
    user { nil }
    type { "" }
    amount { 1.5 }
    account_number { "MyString" }
    active { false }
  end
end
