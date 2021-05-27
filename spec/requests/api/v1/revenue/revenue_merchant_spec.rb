require 'rails_helper'

describe 'Revenue' do
  before(:each) do
    @merchant_2 = create :merchant
    @merchant_3 = create :merchant
    @merchant_4 = create :merchant
    @merchant_5 = create :merchant
    @merchant_6 = create :merchant

    @customer = create :customer

    @item_2a = create :item, merchant: @merchant_2
    @item_2b = create :item, merchant: @merchant_2

    @item_3a = create :item, merchant: @merchant_3
    @item_3b = create :item, merchant: @merchant_3

    @item_4a = create :item, merchant: @merchant_4
    @item_4b = create :item, merchant: @merchant_4

    @item_5a = create :item, merchant: @merchant_5
    @item_5b = create :item, merchant: @merchant_5

    @item_6a = create :item, merchant: @merchant_6
    @item_6b = create :item, merchant: @merchant_6

    # 30 dollars in revenue for merchant 2
    @invoice_2 = @merchant_2.invoices.create!(status: 'shipped', customer: @customer)
    @invoice_2.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
    @invoice_2.invoice_items.create!(item: @item_2a, quantity: 2, unit_price: 10)
    @invoice_2.invoice_items.create!(item: @item_2b, quantity: 10, unit_price: 1)

    # 110 dollars in revenue for merchant 3
    @invoice_3a = @merchant_3.invoices.create!(status: 'shipped', customer: @customer)
    @invoice_3b = @merchant_3.invoices.create!(status: 'shipped', customer: @customer)
    @invoice_3a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
    @invoice_3b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
    @invoice_3a.invoice_items.create!(item: @item_3a, quantity: 10, unit_price: 10)
    @invoice_3b.invoice_items.create!(item: @item_3b, quantity: 10, unit_price: 1)

    # 2 dollars in revenue for merchant 4
    @invoice_4a = @merchant_4.invoices.create!(status: 'shipped', customer: @customer)
    @invoice_4b = @merchant_4.invoices.create!(status: 'shipped', customer: @customer)
    @invoice_4a.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
    @invoice_4b.transactions.create!(result: 'failed', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
    @invoice_4a.invoice_items.create!(item: @item_4a, quantity: 1, unit_price: 1)
    @invoice_4b.invoice_items.create!(item: @item_4b, quantity: 1, unit_price: 1)

    # 10 dollars in revenue for merchant 5
    @invoice_5a = @merchant_5.invoices.create!(status: 'shipped', customer: @customer)
    @invoice_5b = @merchant_5.invoices.create!(status: 'shipped', customer: @customer)
    @invoice_5a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
    @invoice_5b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
    @invoice_5a.invoice_items.create!(item: @item_5a, quantity: 5, unit_price: 1)
    @invoice_5b.invoice_items.create!(item: @item_5b, quantity: 1, unit_price: 5)

    # 12 dollars in revenue for merchant 6
    @invoice_6a = @merchant_6.invoices.create!(status: 'shipped', customer: @customer)
    @invoice_6b = @merchant_6.invoices.create!(status: 'shipped', customer: @customer)
    @invoice_6a.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
    @invoice_6b.transactions.create!(result: 'success', credit_card_number: '12345',
                                     credit_card_expiration_date: '08-24-25')
    @invoice_6a.invoice_items.create!(item: @item_6a, quantity: 6, unit_price: 1)
    @invoice_6b.invoice_items.create!(item: @item_6b, quantity: 2, unit_price: 3)
  end
  describe 'merchants ordered by total revenue' do
    describe 'Happy Path' do
      it 'returns merchant revenue objects' do
        get '/api/v1/revenue/merchants?quantity=3'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchants[:data].count).to eq(3)
        expect(merchants).to be_a Hash
        expect(merchants[:data].first).to have_key(:attributes)
        expect(merchants[:data].first[:attributes]).to have_key(:id)
        expect(merchants[:data].first[:attributes]).to have_key(:name)
        expect(merchants[:data].first[:attributes]).to have_key(:revenue)
      end
      it 'returns merchant revenue based on the quantity provided' do
        get '/api/v1/revenue/merchants?quantity=4'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchants[:data].count).to eq(4)
        expect(merchants).to be_a Hash
        expect(merchants[:data].first).to have_key(:attributes)
        expect(merchants[:data].first[:attributes]).to have_key(:id)
        expect(merchants[:data].first[:attributes]).to have_key(:name)
        expect(merchants[:data].first[:attributes]).to have_key(:revenue)
      end
    end
    describe 'Sad Path' do
      it 'returns an error if no quantity provided' do
        get '/api/v1/revenue/merchants'
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(400)
        expect(merchants).to be_a Hash
        expect(merchants[:errors]).to eq('Must include quantity as an integer')
      end
      it "returns an error if quantity isn't an integer" do
        get '/api/v1/revenue/merchants?quantity=ham'
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(400)
        expect(merchants).to be_a Hash
        expect(merchants[:errors]).to eq('Must include quantity as an integer')
      end
    end
  end
end
