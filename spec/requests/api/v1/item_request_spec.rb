require 'rails_helper'

describe 'Items' do
  describe 'items all' do
    describe 'Happy Path' do
      it 'sends a list of items without a page request' do
        create_list(:item, 25)

        get '/api/v1/items'
        items = JSON.parse(response.body, symbolize_names: true)
        expect(response).to be_successful
        expect(items[:data].count).to eq(20)
        expect(items).to be_a Hash
        expect(items[:data].first).to have_key(:attributes)
        expect(items[:data].first[:attributes]).to have_key(:name)
        expect(items[:data].first[:attributes]).to have_key(:description)
        expect(items[:data].first[:attributes]).to have_key(:unit_price)
      end

      it 'sends a list of items with a page request, and returns expected volume' do
        create_list(:item, 50)

        get '/api/v1/items', params: { page: 3 }

        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(10)
      end

      it 'sends a list of items with no page request, and returns expected volume starting at 1st record' do
        create_list(:item, 50)

        get '/api/v1/items', params: { per_page: 30 }

        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(30)
        expect(Item.first.name).to eq(items[:data].first[:attributes][:name])
        expect(Item.all[29].name).to eq(items[:data].last[:attributes][:name])
      end
    end

    describe 'Sad Path' do
      it 'sends an empty array if no items' do
        get '/api/v1/items', params: { page: 1 }
        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data]).to eq([])
      end

      it 'returns first 20 results if requested page is equal to or less than 0' do
        create_list(:item, 20)

        get '/api/v1/items', params: { page: 0 }
        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)
        expect(Item.first.name).to eq(items[:data].first[:attributes][:name])
        expect(Item.last.name).to eq(items[:data].last[:attributes][:name])
        get '/api/v1/items', params: { page: -1 }
        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)
        expect(Item.first.name).to eq(items[:data].first[:attributes][:name])
        expect(Item.last.name).to eq(items[:data].last[:attributes][:name])
      end

      it 'returns first 20 results if requested per_page is equal to or less than 0' do
        create_list(:item, 20)

        get '/api/v1/items', params: { per_page: 0 }
        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].count).to eq(20)
        get '/api/v1/items', params: { per_page: -1 }
        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].count).to eq(20)
      end

      it 'returns all items if per_page is too high' do
        create_list(:item, 50)

        get '/api/v1/items', params: { per_page: 999 }
        expect(response).to be_successful
        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].count).to eq(50)
      end
    end
  end
  describe 'items show' do
    describe 'Happy Path' do
      it 'returns one Item' do
        item_1= create :item

        get "/api/v1/items/#{item_1.id}"
        item = JSON.parse(response.body, symbolize_names: true)
        
        expect(response).to be_successful
        expect(item.count).to eq(1)
        expect(item).to be_a Hash
        expect(item[:data]).to have_key(:attributes)
        expect(item[:data][:attributes]).to have_key(:name)
      end
    end
    describe 'Sad Path' do
      it 'returns no Item if sent bad id' do
        item_1= create :item, id: 1

        get "/api/v1/items/#{50}"
        item = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(item.count).to eq(1)
        expect(item).to be_a Hash
        expect(item[:data]).to eq([])
      end
    end
  end
end
