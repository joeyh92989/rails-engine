require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'relationships' do
    it { is_expected.to have_many(:items).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end
  describe 'Class Methods' do
    it 'Returns Merchants ordered by revenue' do
      merchant2 = create :merchant
      merchant3 = create :merchant
      merchant4 = create :merchant
      merchant5 = create :merchant
      merchant6 = create :merchant

      customer = create :customer

      item2a = create :item, merchant: merchant2
      item2b = create :item, merchant: merchant2

      item3a = create :item, merchant: merchant3
      item3b = create :item, merchant: merchant3

      item4a = create :item, merchant: merchant4
      item4b = create :item, merchant: merchant4

      item5a = create :item, merchant: merchant5
      item5b = create :item, merchant: merchant5

      item6a = create :item, merchant: merchant6
      item6b = create :item, merchant: merchant6

      # 30 dollars in revenue for merchant 2
      invoice2 = merchant2.invoices.create!(status: 'shipped', customer: customer)
      invoice2.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
      invoice2.invoice_items.create!(item: item2a, quantity: 2, unit_price: 10)
      invoice2.invoice_items.create!(item: item2b, quantity: 10, unit_price: 1)

      # 110 dollars in revenue for merchant 3
      invoice3a = merchant3.invoices.create!(status: 'shipped', customer: customer)
      invoice3b = merchant3.invoices.create!(status: 'shipped', customer: customer)
      invoice3a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3a.invoice_items.create!(item: item3a, quantity: 10, unit_price: 10)
      invoice3b.invoice_items.create!(item: item3b, quantity: 10, unit_price: 1)

      # 2 dollars in revenue for merchant 4
      invoice4a = merchant4.invoices.create!(status: 'shipped', customer: customer)
      invoice4b = merchant4.invoices.create!(status: 'shipped', customer: customer)
      invoice4a.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice4b.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice4a.invoice_items.create!(item: item4a, quantity: 1, unit_price: 1)
      invoice4b.invoice_items.create!(item: item4b, quantity: 1, unit_price: 1)

      # 10 dollars in revenue for merchant 5
      invoice5a = merchant5.invoices.create!(status: 'shipped', customer: customer)
      invoice5b = merchant5.invoices.create!(status: 'shipped', customer: customer)
      invoice5a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice5b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice5a.invoice_items.create!(item: item5a, quantity: 5, unit_price: 1)
      invoice5b.invoice_items.create!(item: item5b, quantity: 1, unit_price: 5)

      # 12 dollars in revenue for merchant 6
      invoice6a = merchant6.invoices.create!(status: 'shipped', customer: customer)
      invoice6b = merchant6.invoices.create!(status: 'shipped', customer: customer)
      invoice6a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice6b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice6a.invoice_items.create!(item: item6a, quantity: 6, unit_price: 1)
      invoice6b.invoice_items.create!(item: item6b, quantity: 2, unit_price: 3)

      # HINT: Invoices must have a successful transaction and be shipped to the customer to be considered as revenue.

      actual = Merchant.merchants_ordered_by_rev(5).map do |merchant|
        merchant
      end
      expected = [merchant3, merchant2, merchant6, merchant5]
      expect(actual).to eq(expected)
      expect(actual.count).to eq(4)
    end
    it "can return a list of merchants by name search" do 
      merchant1 = create :merchant, name: "Steves Goods"
      merchant2 = create :merchant, name: "Ricks Wares "
      merchant3 = create :merchant, name: "Joes Electronics"
      merchant4 = create :merchant, name: "ABCDE and Stuff"
      binding.pry
      expect(Merchant.find_all_by_name("Steves")).to eq([merchant1])
      expect(Merchant.find_all_by_name("es")).to eq([merchant1,merchant2,merchant3])
      expect(Merchant.find_all_by_name("stuff")).to eq([merchant4])
    end
  end
  describe 'instance methods' do
    it 'returns total rev for a merchant' do
      merchant2 = create :merchant
      merchant3 = create :merchant
      merchant4 = create :merchant

      customer = create :customer

      item2a = create :item, merchant: merchant2
      item2b = create :item, merchant: merchant2

      item3a = create :item, merchant: merchant3
      item3b = create :item, merchant: merchant3

      item4a = create :item, merchant: merchant4
      item4b = create :item, merchant: merchant4

      # 30 dollars in revenue for merchant 2
      invoice2 = merchant2.invoices.create!(status: 'shipped', customer: customer)
      invoice2.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
      invoice2.invoice_items.create!(item: item2a, quantity: 2, unit_price: 10)
      invoice2.invoice_items.create!(item: item2b, quantity: 10, unit_price: 1)

      # 110 dollars in revenue for merchant 3
      invoice3a = merchant3.invoices.create!(status: 'shipped', customer: customer)
      invoice3b = merchant3.invoices.create!(status: 'shipped', customer: customer)
      invoice3a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3a.invoice_items.create!(item: item3a, quantity: 10, unit_price: 10)
      invoice3b.invoice_items.create!(item: item3b, quantity: 10, unit_price: 1)

      # 2 dollars in revenue for merchant 4
      invoice4a = merchant4.invoices.create!(status: 'shipped', customer: customer)
      invoice4b = merchant4.invoices.create!(status: 'shipped', customer: customer)
      invoice4a.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice4b.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice4a.invoice_items.create!(item: item4a, quantity: 1, unit_price: 1)
      invoice4b.invoice_items.create!(item: item4b, quantity: 1, unit_price: 1)

      expect(merchant2.total_rev).to eq(30)
      expect(merchant3.total_rev).to eq(110)
      expect(merchant4.total_rev).to eq(0)
    end
  end
end
