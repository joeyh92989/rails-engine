require 'rails_helper'

describe 'Merchants' do
  describe 'Happy Path' do
    it 'sends a list of Merchants without a page request' do
      create_list(:merchant, 25)

      get '/api/v1/merchants'
      merchants = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(merchants[:data].count).to eq(20)
      expect(merchants).to be_a Hash
      expect(merchants[:data].first).to have_key(:attributes)
      expect(merchants[:data].first[:attributes]).to have_key(:name)
    end

    it 'sends a list of Merchants with a page request, and returns expected volume' do
      create_list(:merchant, 50)

      get '/api/v1/merchants', params:{page: 2}

      expect(response).to be_successful
      merchants = JSON.parse(response.body, symbolize_names: true)

      expect(merchants[:data].count).to eq(10)
    end
  end
end
