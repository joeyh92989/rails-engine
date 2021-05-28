require 'rails_helper'

describe 'Revenue' do
  before(:each) do
    @merchant2 = create :merchant
    @merchant3 = create :merchant
    @merchant4 = create :merchant
    @merchant5 = create :merchant
    @merchant6 = create :merchant
    @merchant7 = create :merchant
    @merchant8 = create :merchant
    @merchant9 = create :merchant
    @merchant10= create :merchant

    @customer = create :customer

    @item2 = create :item, merchant: @merchant2
    @item3 = create :item, merchant: @merchant3
    @item4 = create :item, merchant: @merchant4
    @item5 = create :item, merchant: @merchant5
    @item6 = create :item, merchant: @merchant6
    @item7 = create :item, merchant: @merchant7
    @item8 = create :item, merchant: @merchant8
    @item9 = create :item, merchant: @merchant9
    @item10 = create :item, merchant: @merchant10

    # 30 dollars in revenue for merchant 2
    @invoice2 = @merchant2.invoices.create!(status: 'shipped', customer: @customer)
    @invoice2a = @merchant2.invoices.create!(status: 'shipped', customer: @customer)
    @invoice2.transactions.create!(result: 'success', credit_card_number: '12345',
                                  credit_card_expiration_date: '08-24-25')
    @invoice2a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice2.invoice_items.create!(item: @item2, quantity: 2, unit_price: 10)
    @invoice2a.invoice_items.create!(item: @item2, quantity: 10, unit_price: 1)

    # 110 dollars in revenue for merchant 3
    @invoice3a = @merchant3.invoices.create!(status: 'shipped', customer: @customer)
    @invoice3b = @merchant3.invoices.create!(status: 'shipped', customer: @customer)
    @invoice3a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice3b.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice3a.invoice_items.create!(item: @item3, quantity: 10, unit_price: 10)
    @invoice3b.invoice_items.create!(item: @item3, quantity: 10, unit_price: 1)

    # 2 dollars in revenue for merchant 4
    @invoice4a = @merchant4.invoices.create!(status: 'shipped', customer: @customer)
    @invoice4b = @merchant4.invoices.create!(status: 'shipped', customer: @customer)
    @invoice4a.transactions.create!(result: 'failed', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice4b.transactions.create!(result: 'failed', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice4a.invoice_items.create!(item: @item4, quantity: 1, unit_price: 1)
    @invoice4b.invoice_items.create!(item: @item4, quantity: 1, unit_price: 1)

    # 10 dollars in revenue for merchant 5
    @invoice5a = @merchant5.invoices.create!(status: 'shipped', customer: @customer)
    @invoice5b = @merchant5.invoices.create!(status: 'shipped', customer: @customer)
    @invoice5a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice5b.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice5a.invoice_items.create!(item: @item5, quantity: 5, unit_price: 1)
    @invoice5b.invoice_items.create!(item: @item5, quantity: 1, unit_price: 5)

    # 12 dollars in revenue for merchant 6
    @invoice6a = @merchant6.invoices.create!(status: 'shipped', customer: @customer)
    @invoice6b = @merchant6.invoices.create!(status: 'shipped', customer: @customer)
    @invoice6a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice6b.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice6a.invoice_items.create!(item: @item6, quantity: 6, unit_price: 1)
    @invoice6b.invoice_items.create!(item: @item6, quantity: 2, unit_price: 3)
    # 18 dollars
    @invoice7a = @merchant7.invoices.create!(status: 'shipped', customer: @customer)
    @invoice7b = @merchant7.invoices.create!(status: 'shipped', customer: @customer)
    @invoice7a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice7b.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice7a.invoice_items.create!(item: @item7, quantity: 6, unit_price: 2)
    @invoice7b.invoice_items.create!(item: @item7, quantity: 2, unit_price: 3)
    # 14 dollars
    @invoice8a = @merchant8.invoices.create!(status: 'shipped', customer: @customer)
    @invoice8b = @merchant8.invoices.create!(status: 'shipped', customer: @customer)
    @invoice8a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice8b.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice8a.invoice_items.create!(item: @item8, quantity: 4, unit_price: 2)
    @invoice8b.invoice_items.create!(item: @item8, quantity: 2, unit_price: 3)
    # 26 dollars
    @invoice9a = @merchant9.invoices.create!(status: 'shipped', customer: @customer)
    @invoice9b = @merchant9.invoices.create!(status: 'shipped', customer: @customer)
    @invoice9a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice9b.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice9a.invoice_items.create!(item: @item9, quantity: 10, unit_price: 2)
    @invoice9b.invoice_items.create!(item: @item9, quantity: 2, unit_price: 3)
        # 46 dollars
    @invoice10a = @merchant10.invoices.create!(status: 'shipped', customer: @customer)
    @invoice10b = @merchant10.invoices.create!(status: 'shipped', customer: @customer)
    @invoice10a.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice10b.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice10a.invoice_items.create!(item: @item10, quantity: 20, unit_price: 2)
    @invoice10b.invoice_items.create!(item: @item10, quantity: 2, unit_price: 3)
  end
  describe 'Total Rev for a single merchant' do
    describe 'Happy path' do
      it 'returns items ranked by revenue with a revenue attribute' do
        get '/api/v1/revenue/items?quantity=1'
        items = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(items[:data].count).to eq(1)
        expect(items).to be_a Hash
        expect(items[:data].first).to have_key(:attributes)
        expect(items[:data].first[:attributes]).to have_key(:name)
        expect(items[:data].first[:attributes]).to have_key(:description)
        expect(items[:data].first[:attributes]).to have_key(:unit_price)
        expect(items[:data].first[:attributes]).to have_key(:merchant_id)
        expect(items[:data].first[:attributes]).to have_key(:revenue)
      end
      it 'returns items by quantity specified' do
        get '/api/v1/revenue/items?quantity=5'
        items = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(items[:data].count).to eq(5)
        expect(items).to be_a Hash
        expect(items[:data].first).to have_key(:attributes)
        expect(items[:data].first[:attributes]).to have_key(:name)
        expect(items[:data].first[:attributes]).to have_key(:description)
        expect(items[:data].first[:attributes]).to have_key(:unit_price)
        expect(items[:data].first[:attributes]).to have_key(:merchant_id)
        expect(items[:data].first[:attributes]).to have_key(:revenue)
      end
      it 'returns 10 items when no quantity specified' do
        get '/api/v1/revenue/items'
        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful

        expect(items[:data].count).to eq(8)
        expect(items).to be_a Hash
        expect(items[:data].first).to have_key(:attributes)
        expect(items[:data].first[:attributes]).to have_key(:name)
        expect(items[:data].first[:attributes]).to have_key(:description)
        expect(items[:data].first[:attributes]).to have_key(:unit_price)
        expect(items[:data].first[:attributes]).to have_key(:merchant_id)
        expect(items[:data].first[:attributes]).to have_key(:revenue)
      end
    end
    describe 'Sad path' do
      it 'returns a bad request when quantity is not an integer' do
        get '/api/v1/revenue/items?quantity=ham'
        items = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(400)
        expect(items).to be_a Hash
        expect(items[:errors]).to eq('Must include quantity as an integer')
      end
    end
  end
end
