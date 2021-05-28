require 'rails_helper'

describe 'Revenue' do
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
    @invoice2 = @merchant2.invoices.create!(status: 'shipped', customer: @customer)
    @invoice2.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice2.invoice_items.create!(item: @item2a, quantity: 2, unit_price: 10)
    @invoice2.invoice_items.create!(item: @item2b, quantity: 10, unit_price: 1)

    # 110 dollars in revenue for merchant 3
    @invoice3a = @merchant3.invoices.create!(status: 'shipped', customer: @customer)
    @invoice3b = @merchant3.invoices.create!(status: 'shipped', customer: @customer)
    @invoice3a.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
    @invoice3b.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
    @invoice3a.invoice_items.create!(item: @item3a, quantity: 10, unit_price: 10)
    @invoice3b.invoice_items.create!(item: @item3b, quantity: 10, unit_price: 1)

    # 2 dollars in revenue for merchant 4
    @invoice4a = @merchant4.invoices.create!(status: 'shipped', customer: @customer)
    @invoice4b = @merchant4.invoices.create!(status: 'shipped', customer: @customer)
    @invoice4a.transactions.create!(result: 'failed', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
    @invoice4b.transactions.create!(result: 'failed', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
    @invoice4a.invoice_items.create!(item: @item4a, quantity: 1, unit_price: 1)
    @invoice4b.invoice_items.create!(item: @item4b, quantity: 1, unit_price: 1)

    # 10 dollars in revenue for merchant 5
    @invoice5a = @merchant5.invoices.create!(status: 'shipped', customer: @customer)
    @invoice5b = @merchant5.invoices.create!(status: 'shipped', customer: @customer)
    @invoice5a.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
    @invoice5b.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
    @invoice5a.invoice_items.create!(item: @item5a, quantity: 5, unit_price: 1)
    @invoice5b.invoice_items.create!(item: @item5b, quantity: 1, unit_price: 5)

    # 12 dollars in revenue for merchant 6
    @invoice6a = @merchant6.invoices.create!(status: 'shipped', customer: @customer)
    @invoice6b = @merchant6.invoices.create!(status: 'shipped', customer: @customer)
    @invoice6a.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
    @invoice6b.transactions.create!(result: 'success', credit_card_number: '12345',
                                    credit_card_expiration_date: '08-24-25')
    @invoice6a.invoice_items.create!(item: @item6a, quantity: 6, unit_price: 1)
    @invoice6b.invoice_items.create!(item: @item6b, quantity: 2, unit_price: 3)
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
