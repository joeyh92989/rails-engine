require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to have_many(:invoice_items).dependent(:destroy) }
    it { is_expected.to have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:merchant_id) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_numericality_of(:unit_price) }
  end
  describe 'instance methods' do
    it 'can return any invoice where it is the only item on the invoice' do
      merchant = create :merchant
      item1 = create :item, merchant: merchant
      item2 = create :item, merchant: merchant
      item3 = create :item, merchant: merchant
      invoice1 = create :invoice, merchant: merchant
      invoice2 = create :invoice, merchant: merchant
      create :invoice_item, item: item1, invoice: invoice1
      create :invoice_item, item: item2, invoice: invoice1
      create :invoice_item, item: item3, invoice: invoice2
      expect(item1.lone_invoice).to eq([])
      expect(item3.lone_invoice).to eq([invoice2])
    end
    it 'can return the total revenue from an individual item' do
      merchant2 = create :merchant
      customer = create :customer

      item1 = create :item, merchant: merchant2
      item2 = create :item, merchant: merchant2

      # 30 dollars in revenue for merchant 2
      invoice2 = merchant2.invoices.create!(status: 'shipped', customer: customer)
      invoice2a = merchant2.invoices.create!(status: 'shipped', customer: customer)
      invoice2.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
      invoice2a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice2.invoice_items.create!(item: item1, quantity: 2, unit_price: 10)
      invoice2a.invoice_items.create!(item: item1, quantity: 10, unit_price: 1)

      # 110 dollars in revenue for merchant 3
      invoice3a = merchant2.invoices.create!(status: 'shipped', customer: customer)
      invoice3b = merchant2.invoices.create!(status: 'shipped', customer: customer)
      invoice3a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3a.invoice_items.create!(item: item2, quantity: 10, unit_price: 10)
      invoice3b.invoice_items.create!(item: item2, quantity: 10, unit_price: 1)

      expect(item1.total_rev).to eq(30)
      expect(item2.total_rev).to eq(110)
    end
  end
  describe 'class methods' do
    it 'can return items ordered by revenue' do
      merchant2 = create :merchant
      merchant3 = create :merchant
      merchant4 = create :merchant
      merchant5 = create :merchant
      merchant6 = create :merchant

      customer = create :customer

      item2 = create :item, merchant: merchant2

      item3 = create :item, merchant: merchant3

      item4 = create :item, merchant: merchant4

      item5 = create :item, merchant: merchant5

      item6 = create :item, merchant: merchant6

      # 30 dollars in revenue for merchant 2
      invoice2 = merchant2.invoices.create!(status: 'shipped', customer: customer)
      invoice2a = merchant2.invoices.create!(status: 'shipped', customer: customer)
      invoice2.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
      invoice2a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice2.invoice_items.create!(item: item2, quantity: 2, unit_price: 10)
      invoice2a.invoice_items.create!(item: item2, quantity: 10, unit_price: 1)

      # 110 dollars in revenue for merchant 3
      invoice3a = merchant3.invoices.create!(status: 'shipped', customer: customer)
      invoice3b = merchant3.invoices.create!(status: 'shipped', customer: customer)
      invoice3a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice3a.invoice_items.create!(item: item3, quantity: 10, unit_price: 10)
      invoice3b.invoice_items.create!(item: item3, quantity: 10, unit_price: 1)

      # 2 dollars in revenue for merchant 4
      invoice4a = merchant4.invoices.create!(status: 'shipped', customer: customer)
      invoice4b = merchant4.invoices.create!(status: 'shipped', customer: customer)
      invoice4a.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice4b.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice4a.invoice_items.create!(item: item4, quantity: 1, unit_price: 1)
      invoice4b.invoice_items.create!(item: item4, quantity: 1, unit_price: 1)

      # 10 dollars in revenue for merchant 5
      invoice5a = merchant5.invoices.create!(status: 'shipped', customer: customer)
      invoice5b = merchant5.invoices.create!(status: 'shipped', customer: customer)
      invoice5a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice5b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice5a.invoice_items.create!(item: item5, quantity: 5, unit_price: 1)
      invoice5b.invoice_items.create!(item: item5, quantity: 1, unit_price: 5)

      # 12 dollars in revenue for merchant 6
      invoice6a = merchant6.invoices.create!(status: 'shipped', customer: customer)
      invoice6b = merchant6.invoices.create!(status: 'shipped', customer: customer)
      invoice6a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice6b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
      invoice6a.invoice_items.create!(item: item6, quantity: 6, unit_price: 1)
      invoice6b.invoice_items.create!(item: item6, quantity: 2, unit_price: 3)

      expect(Item.items_sorted_by_rev(2)).to eq([item3, item2])
      expect(Item.items_sorted_by_rev(5)).to eq([item3, item2, item6, item5])
    end
    it 'can return an item by name search' do
      item1 = create :item, name: 'spatula'
      item2 = create :item, name: 'spoon'
      item3 = create :item, name: 'fork'
      item4 = create :item, name: 'knife'

      expect(Item.find_by_name('kn')).to eq(item4)
      expect(Item.find_by_name('spo')).to eq(item2)
    end
    it 'can return an item by by max and min search' do
      item1 = create :item, name: 'spatula', unit_price: 15.00
      item2 = create :item, name: 'spoon', unit_price: 20.00
      item3 = create :item, name: 'fork', unit_price: 10.00
      item4 = create :item, name: 'knife', unit_price: 12.00
      expect(Item.find_by_price(10, 15)).to eq(item3)
      expect(Item.find_by_price_max(10)).to eq(item3)
      expect(Item.find_by_price_min(15)).to eq(item1)
    end
  end
end
