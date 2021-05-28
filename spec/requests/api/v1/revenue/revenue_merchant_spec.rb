require 'rails_helper'

describe 'Revenue' do
  before(:each) do
    @merchant2 = create :merchant, id: 2

    @customer = create :customer

    @item2a = create :item, merchant: @merchant2
    @item2b = create :item, merchant: @merchant2

    # 30 dollars in revenue for merchant 2
    @invoice2 = @merchant2.invoices.create!(status: 'shipped', customer: @customer)
    @invoice2.transactions.create!(result: 'success', credit_card_number: '12345',
                                   credit_card_expiration_date: '08-24-25')
    @invoice2.invoice_items.create!(item: @item2a, quantity: 2, unit_price: 10)
    @invoice2.invoice_items.create!(item: @item2b, quantity: 10, unit_price: 1)
  end
  describe 'Total Rev for a single merchant' do
    describe 'Happy path' do
      it 'returns total revenue for a single merchant' do
        get '/api/v1/revenue/merchants/2'
        merchant = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(merchant).to be_a Hash
        expect(merchant[:data]).to have_key(:attributes)
        expect(merchant[:data][:attributes]).to have_key(:revenue)
        expect(merchant[:data][:attributes][:revenue]).to eq(30.0)
      end
    end
    describe 'Sad path' do
      it 'returns a not found when merchant id is bad' do
        get '/api/v1/revenue/merchants/1'
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response.status).to eq(404)
        expect(merchant).to be_a Hash
      end
    end
  end
end
