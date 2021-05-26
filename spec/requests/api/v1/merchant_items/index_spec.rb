require 'rails_helper'

describe 'Merchant Items' do
  describe 'merchant items all' do
    describe 'Happy Path' do
      it 'sends a list of items' do
        merchant = create :merchant
        create_list :item, 10, merchant: merchant

        get "/api/v1/merchants/#{merchant.id}/items"
        items = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(items[:data].count).to eq(10)
        expect(items).to be_a Hash
        expect(items[:data].first).to have_key(:attributes)
        expect(items[:data].first[:attributes]).to have_key(:name)
        expect(items[:data].first[:attributes]).to have_key(:description)
        expect(items[:data].first[:attributes]).to have_key(:unit_price)
        expect(items[:data].first[:attributes]).to have_key(:merchant_id)
      end
    end

    describe 'Sad Path' do
      it 'sends an empty array if no merchants' do
        get '/api/v1/merchants/50/items'
        expect(response.status).to eq(404)
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(merchants[:data]).to eq([])
      end
    end
  end
end
