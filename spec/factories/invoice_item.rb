FactoryBot.define do
  factory :invoice_item do
    quantity { Faker::Number.within(range: 1..10) }
    unit_price { Faker::Number.decimal(r_digits: 2) }
    invoice
    item
  end
end
