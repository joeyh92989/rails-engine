require 'rails_helper'

describe 'Item Merchant' do
  describe 'Item Merchant ' do
    describe 'Happy Path' do
      it 'sends a merchant' do
        merchant = create :merchant
        item = create :item, merchant: merchant

        get "/api/v1/items/#{item.id}/merchant"
        merchant = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(merchant).to be_a Hash
        expect(merchant[:data]).to have_key(:attributes)
        expect(merchant[:data][:attributes]).to have_key(:name)
      end
    end

    describe 'Sad Path' do
      it 'sends an empty array if no merchants' do
        get '/api/v1/items/1/merchant'
        expect(response.status).to eq(404)
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(merchants[:data]).to eq([])
      end
    end
  end
end
