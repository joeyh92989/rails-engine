require 'rails_helper'

describe 'item Search' do
  describe 'item search' do
    describe 'Happy Path' do
      it 'returns  objects' do
        create :item, name: 'Test'
        create :item, unit_price: 100

        get '/api/v1/items/find?name=T'
        item = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(item.count).to eq(1)
        expect(item).to be_a Hash
        expect(item[:data]).to have_key(:attributes)
        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes]).to have_key(:merchant_id)

        get '/api/v1/items/find?max_price=150&min_price=50'
        item2 = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(item2.count).to eq(1)
        expect(item2).to be_a Hash
        expect(item2[:data]).to have_key(:attributes)
        expect(item2[:data][:attributes]).to have_key(:name)
        expect(item2[:data][:attributes]).to have_key(:description)
        expect(item2[:data][:attributes]).to have_key(:unit_price)
        expect(item2[:data][:attributes]).to have_key(:merchant_id)
      end
      it 'returns  an item with max  price param' do
        create :item, unit_price: 100
        get '/api/v1/items/find?max_price=120'
        item2 = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(item2.count).to eq(1)
        expect(item2).to be_a Hash
        expect(item2[:data]).to have_key(:attributes)
        expect(item2[:data][:attributes]).to have_key(:name)
        expect(item2[:data][:attributes]).to have_key(:description)
        expect(item2[:data][:attributes]).to have_key(:unit_price)
        expect(item2[:data][:attributes]).to have_key(:merchant_id)
      end
      it 'returns  an item with min  price param' do
        create :item, unit_price: 100
        get '/api/v1/items/find?min_price=100'
        item2 = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(item2.count).to eq(1)
        expect(item2).to be_a Hash
        expect(item2[:data]).to have_key(:attributes)
        expect(item2[:data][:attributes]).to have_key(:name)
        expect(item2[:data][:attributes]).to have_key(:description)
        expect(item2[:data][:attributes]).to have_key(:unit_price)
        expect(item2[:data][:attributes]).to have_key(:merchant_id)
      end
    end

    describe 'Sad Path' do
      it 'returns no item if none found' do
        get '/api/v1/items/find?name=a'
        item = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(item).to be_a Hash
        expect(item[:data]).to eq(nil)
      end
      it 'returns error if syntax is wrong' do
        get '/api/v1/items/find'

        item = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(400)
        expect(item).to be_a Hash
        expect(item[:errors]).to eq('search params incorrect')
      end
    end
  end
end