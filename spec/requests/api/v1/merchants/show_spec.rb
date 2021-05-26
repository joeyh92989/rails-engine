require 'rails_helper'

describe 'Merchants' do
  describe 'merchants show' do
    describe 'Happy Path' do
      it 'returns one merchant' do
        merchant_1 = create :merchant

        get "/api/v1/merchants/#{merchant_1.id}"
        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(merchant.count).to eq(1)
        expect(merchant).to be_a Hash
        expect(merchant[:data]).to have_key(:attributes)
        expect(merchant[:data][:attributes]).to have_key(:name)
      end
    end

    describe 'Sad Path' do
      it 'returns no merchant if sent bad id' do
        merchant_1 = create :merchant, id: 1

        get '/api/v1/merchants/50'
        merchant = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(merchant.count).to eq(1)
        expect(merchant).to be_a Hash
        expect(merchant[:data]).to eq([])
      end
    end
  end
end
