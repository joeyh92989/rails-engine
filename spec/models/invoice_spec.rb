require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to have_many(:invoice_items).dependent(:destroy) }
    it { is_expected.to have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
  end
  describe 'class methods' do
    it 'can return a specified amount of invoices ordered by revenue unshipped' do
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
      invoice2 = merchant2.invoices.create!(status: 'packaged', customer: customer)
      invoice2.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
      invoice2.invoice_items.create!(item: item2a, quantity: 2, unit_price: 10)
      invoice2.invoice_items.create!(item: item2b, quantity: 10, unit_price: 1)

      # 110 dollars in revenue for merchant 3
      invoice3a = merchant3.invoices.create!(status: 'packaged', customer: customer)
      invoice3b = merchant3.invoices.create!(status: 'packaged', customer: customer)
      invoice3a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3a.invoice_items.create!(item: item3a, quantity: 10, unit_price: 10)
      invoice3b.invoice_items.create!(item: item3b, quantity: 10, unit_price: 1)

      # 2 dollars in revenue for merchant 4
      invoice4a = merchant4.invoices.create!(status: 'packaged', customer: customer)
      invoice4b = merchant4.invoices.create!(status: 'packaged', customer: customer)
      invoice4a.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice4b.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice4a.invoice_items.create!(item: item4a, quantity: 1, unit_price: 1)
      invoice4b.invoice_items.create!(item: item4b, quantity: 1, unit_price: 1)

      # 10 dollars in revenue for merchant 5
      invoice5a = merchant5.invoices.create!(status: 'packaged', customer: customer)
      invoice5b = merchant5.invoices.create!(status: 'packaged', customer: customer)
      invoice5a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice5b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice5a.invoice_items.create!(item: item5a, quantity: 5, unit_price: 1)
      invoice5b.invoice_items.create!(item: item5b, quantity: 1, unit_price: 5)

      # 12 dollars in revenue for merchant 6
      invoice6a = merchant6.invoices.create!(status: 'packaged', customer: customer)
      invoice6b = merchant6.invoices.create!(status: 'packaged', customer: customer)
      invoice6a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice6b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice6a.invoice_items.create!(item: item6a, quantity: 6, unit_price: 1)
      invoice6b.invoice_items.create!(item: item6b, quantity: 2, unit_price: 3)

      expect(Invoice.invoices_sorted_by_rev(10)).to eq([invoice3a, invoice2, invoice3b, invoice6a, invoice6b, invoice5a,
                                                        invoice5b])
      expect(Invoice.invoices_sorted_by_rev(10).length).to eq(7)
    end
  end
  describe 'Instance methods' do
    it 'can return the revenue of a possible revenue of a single invoice' do
      merchant3 = create :merchant
      merchant4 = create :merchant

      customer = create :customer

      item3a = create :item, merchant: merchant3
      item3b = create :item, merchant: merchant3

      item4a = create :item, merchant: merchant4
      item4b = create :item, merchant: merchant4

      # 110 dollars in revenue for merchant 3
      invoice3a = merchant3.invoices.create!(status: 'packaged', customer: customer)
      invoice3b = merchant3.invoices.create!(status: 'packaged', customer: customer)
      invoice3a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3a.invoice_items.create!(item: item3a, quantity: 10, unit_price: 10)
      invoice3b.invoice_items.create!(item: item3b, quantity: 10, unit_price: 1)

      # 2 dollars in revenue for merchant 4
      invoice4a = merchant4.invoices.create!(status: 'packaged', customer: customer)
      invoice4b = merchant4.invoices.create!(status: 'packaged', customer: customer)
      invoice4a.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice4b.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice4a.invoice_items.create!(item: item4a, quantity: 1, unit_price: 1)
      invoice4b.invoice_items.create!(item: item4b, quantity: 1, unit_price: 1)

      expect(invoice3a.total_rev).to eq(100)
      expect(invoice3b.total_rev).to eq(10)
      expect(invoice4a.total_rev).to eq(0)
      expect(invoice4b.total_rev).to eq(0)
    end
  end
end
