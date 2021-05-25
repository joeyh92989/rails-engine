require 'rails_helper'

describe 'Merchants' do
  describe 'Happy Path' do
    it 'sends a list of Merchants without a page request' do
      create_list(:merchant, 25)

      get '/api/v1/merchants'

      expect(response).to be_successful
      merchants = JSON.parse(response.body)
      expect(merchants.count).to eq(20)
      merchants.each do |merchant|
        expect(merchant).to have_key('name')
        expect(merchant['name']).to be_an(String)
        expect(merchant).to have_key('id')
        expect(merchant['id']).to be_an(Integer)
      end
    end

    it 'sends a list of Merchants with a page request, and returns expected volume' do
      create_list(:merchant, 50)

      get '/api/v1/merchants', params:{page: 2}

      expect(response).to be_successful
      merchants = JSON.parse(response.body)
      expect(merchants.count).to eq(10)
    end
  end
end
