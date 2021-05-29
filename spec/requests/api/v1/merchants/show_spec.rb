require 'rails_helper'

describe 'Merchants' do
  describe 'merchants show' do
    describe 'Happy Path' do
      it 'returns one merchant' do
        create :merchant, id: 1

        get '/api/v1/merchants/1'
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
        create :merchant, id: 1

        get '/api/v1/merchants/50'
        merchant = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(merchant).to be_a Hash
        expect(merchant[:data][:type]).to eq('merchant')
        expect(merchant[:data]).to have_key(:attributes)
        expect(merchant[:data][:attributes]).to have_key(:name)
      end
    end
  end
end
