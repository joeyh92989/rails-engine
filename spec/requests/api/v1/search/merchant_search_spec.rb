require 'rails_helper'

describe 'Merchants Search' do
  describe 'merchants' do
    describe 'Happy Path' do
      it 'returns merchant objects' do
        create :merchant, name: "Test"

        get '/api/v1/merchants/find_all?name=t'
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(merchants.count).to eq(1)
        expect(merchants).to be_a Hash
        expect(merchants[:data].first).to have_key(:attributes)
        expect(merchants[:data].first[:attributes]).to have_key(:name)
      end
    end

    describe 'Sad Path' do
      it 'returns no merchant if none found' do
        create :merchant, name: 'test'
        create :merchant, name: 'test1'
        create :merchant, name: 'test2'

        get '/api/v1/merchants/find_all?name=a'
        merchants = JSON.parse(response.body, symbolize_names: true)
        binding.pry
        expect(response.status).to eq(404)
        expect(merchants).to be_a Hash
        expect(merchants[:data]).to eq([])
      end
    end
  end
end
