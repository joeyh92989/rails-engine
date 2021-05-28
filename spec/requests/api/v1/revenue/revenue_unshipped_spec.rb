require 'rails_helper'

describe 'Revenue Unshipped Items' do
  before(:each) do
    @merchant2 = create :merchant
    @merchant3 = create :merchant
    @merchant4 = create :merchant
    @merchant5 = create :merchant
    @merchant6 = create :merchant

    @customer = create :customer

    @item2a = create :item, merchant: @merchant2
    @item2b = create :item, merchant: @merchant2

    @item3a = create :item, merchant: @merchant3
    @item3b = create :item, merchant: @merchant3

    @item4a = create :item, merchant: @merchant4
    @item4b = create :item, merchant: @merchant4

    @item5a = create :item, merchant: @merchant5
    @item5b = create :item, merchant: @merchant5

    @item6a = create :item, merchant: @merchant6
    @item6b = create :item, merchant: @merchant6

    # 30 dollars in revenue for merchant 2
    @invoice2 = @merchant2.invoices.create!(status: 'packaged', customer: @customer)
    @invoice2.transactions.create!(result: 'success', credit_card_number: '12345',
                                  credit_card_expiration_date: '08-24-25')
    @invoice2.invoice_items.create!(item: @item2a, quantity: 2, unit_price: 10)
    @invoice2.invoice_items.create!(item: @item2b, quantity: 10, unit_price: 1)

    # 110 dollars in revenue for merchant 3
    @invoice3a = @merchant3.invoices.create!(status: 'packaged', customer: @customer)
    @invoice3b = @merchant3.invoices.create!(status: 'packaged', customer: @customer)
    @invoice3a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice3b.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice3a.invoice_items.create!(item: @item3a, quantity: 10, unit_price: 10)
    @invoice3b.invoice_items.create!(item: @item3b, quantity: 10, unit_price: 1)

    # 2 dollars in revenue for merchant 4
    @invoice4a = @merchant4.invoices.create!(status: 'packaged', customer: @customer)
    @invoice4b = @merchant4.invoices.create!(status: 'packaged', customer: @customer)
    @invoice4a.transactions.create!(result: 'failed', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice4b.transactions.create!(result: 'failed', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice4a.invoice_items.create!(item: @item4a, quantity: 1, unit_price: 1)
    @invoice4b.invoice_items.create!(item: @item4b, quantity: 1, unit_price: 1)

    # 10 dollars in revenue for merchant 5
    @invoice5a = @merchant5.invoices.create!(status: 'packaged', customer: @customer)
    @invoice5b = @merchant5.invoices.create!(status: 'packaged', customer: @customer)
    @invoice5a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice5b.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice5a.invoice_items.create!(item: @item5a, quantity: 5, unit_price: 1)
    @invoice5b.invoice_items.create!(item: @item5b, quantity: 1, unit_price: 5)

    # 12 dollars in revenue for merchant 6
    @invoice6a = @merchant6.invoices.create!(status: 'packaged', customer: @customer)
    @invoice6b = @merchant6.invoices.create!(status: 'packaged', customer: @customer)
    @invoice6a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice6b.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice6a.invoice_items.create!(item: @item6a, quantity: 6, unit_price: 1)
    @invoice6b.invoice_items.create!(item: @item6b, quantity: 2, unit_price: 3)
  end
  describe 'orders by potential revenue' do
    describe 'Happy Path' do
      it 'returns unshipped orders objects' do
        get '/api/v1/revenue/unshipped?quantity=1'
        invoices = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(invoices[:data].count).to eq(1)
        expect(invoices).to be_a Hash
        expect(invoices[:data].first).to have_key(:attributes)
        expect(invoices[:data].first[:attributes]).to have_key(:potential_revenue)
      end
      it 'returns unshipped orders  based on the quantity provided' do
        get '/api/v1/revenue/unshipped?quantity=3'
        invoices = JSON.parse(response.body, symbolize_names: true)

        expect(invoices[:data].count).to eq(3)
        expect(response).to be_successful
        expect(invoices).to be_a Hash
        expect(invoices[:data].first).to have_key(:attributes)
        expect(invoices[:data].first[:attributes]).to have_key(:potential_revenue)
      end
      it 'returns 10 unshipped orders when no quantity specified' do
        get '/api/v1/revenue/unshipped'
        invoices = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful

        expect(invoices[:data].count).to eq(7)
        expect(invoices).to be_a Hash
        expect(invoices[:data].first).to have_key(:attributes)
        expect(invoices[:data].first[:attributes]).to have_key(:potential_revenue)
      end
    end
    describe 'Sad Path' do
      it "returns an error if quantity isn't an integer" do
        get '/api/v1/revenue/unshipped?quantity=ham'
        invoices = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(400)
        expect(invoices).to be_a Hash
        expect(invoices[:errors]).to eq('Must include quantity as an integer')
      end
    end
  end
end
