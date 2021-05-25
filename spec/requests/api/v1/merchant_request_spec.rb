require 'rails_helper'

describe 'Merchants' do
  describe 'merchants all' do
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

        get '/api/v1/merchants', params: { page: 3 }

        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(10)
      end
      it 'sends a list of Merchants with no page request, and returns expected volume starting at 1st record' do
        create_list(:merchant, 50)

        get '/api/v1/merchants', params: { per_page: 30 }

        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(30)
        expect(Merchant.first.name).to eq(merchants[:data].first[:attributes][:name])
        expect(Merchant.all[29].name).to eq(merchants[:data].last[:attributes][:name])
      end
    end

    describe 'Sad Path' do
      it 'sends an empty array if no merchants' do


        get '/api/v1/merchants', params: { page: 1 }
        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(merchants[:data]).to eq([])

      end
      it 'returns first 20 results if requested page is equal to or less than 0' do
        create_list(:merchant, 20)

        get '/api/v1/merchants', params: { page: 0 }
        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(Merchant.first.name).to eq(merchants[:data].first[:attributes][:name])
        expect(Merchant.last.name).to eq(merchants[:data].last[:attributes][:name])
        get '/api/v1/merchants', params: { page: -1 }
        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(Merchant.first.name).to eq(merchants[:data].first[:attributes][:name])
        expect(Merchant.last.name).to eq(merchants[:data].last[:attributes][:name])
      end
      it 'returns first 20 results if requested per_page is equal to or less than 0' do
        create_list(:merchant, 20)

        get '/api/v1/merchants', params: { per_page: 0 }
        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(merchants[:data].count).to eq(20)
        get '/api/v1/merchants', params: { per_page: -1 }
        expect(response).to be_successful
        merchants = JSON.parse(response.body, symbolize_names: true)
        expect(merchants[:data].count).to eq(20)
      end
    end
  end
end
