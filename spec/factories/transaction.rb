FactoryBot.define do
  factory :transaction do
    credit_card_number { Faker::Bank.account_number(digits: 16).to_s }
    credit_card_expiration_date { Faker::Date.between(from: '2021-09-23', to: '2025-09-25').to_s }
    result { "success" }
    invoice
  end
end
