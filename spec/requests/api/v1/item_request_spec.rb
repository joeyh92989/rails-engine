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
        expect(items[:data].first[:attributes]).to have_key(:merchant_id)
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
        item_1 = create :item

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
        item_1 = create :item, id: 1

        get '/api/v1/items/50'
        item = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(item.count).to eq(1)
        expect(item).to be_a Hash
        expect(item[:data]).to eq([])
      end
    end
  end
  describe 'item create' do
    describe 'Happy Path' do
      it 'creates a new item and returns it as a response' do
        merchant = create :merchant
        post '/api/v1/items',
             params: { name: 'test', description: 'lorem ipsum', unit_price: 19.50, merchant_id: merchant.id }

        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(201)
        expect(item[:data][:attributes][:name]).to eq('test')
        expect(item[:data][:attributes][:description]).to eq('lorem ipsum')
        expect(item[:data][:attributes][:unit_price]).to eq(19.5)
        expect(item[:data][:attributes][:merchant_id]).to eq(merchant.id)
        expect(Item.count).to eq(1)
      end
    end
    describe 'Sad Path' do
      it 'returns a fail when user enters no params' do
        merchant = create :merchant
        post '/api/v1/items'

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item[:errors]).to be_a(Array)
        expect(response.status).to eq(400)
      end
    end
  end
  describe 'item update' do
    describe 'Happy Path' do
      it 'can update an item name' do
        merchant = create :merchant
        item = create :item, name: 'Steve', id: 1, merchant: merchant
        patch '/api/v1/items/1', params: { name: 'test' }
        item_resp = JSON.parse(response.body, symbolize_names: true)
        expect(item_resp[:data][:attributes][:name]).to eq('test')
        expect(item_resp[:data][:attributes][:description]).to eq(item.description)
        expect(item_resp[:data][:attributes][:unit_price]).to eq(item.unit_price)
        expect(item_resp[:data][:attributes][:merchant_id]).to eq(merchant.id)
      end
      it 'can update an item description' do
        merchant = create :merchant
        item = create :item, description: 'i like candy', id: 1, merchant: merchant
        patch '/api/v1/items/1', params: { description: 'my favorite is gummy bears' }
        item_resp = JSON.parse(response.body, symbolize_names: true)
        expect(item_resp[:data][:attributes][:name]).to eq(item.name)
        expect(item_resp[:data][:attributes][:description]).to eq('my favorite is gummy bears')
        expect(item_resp[:data][:attributes][:unit_price]).to eq(item.unit_price)
        expect(item_resp[:data][:attributes][:merchant_id]).to eq(merchant.id)
      end
      it 'can update an item price' do
        merchant = create :merchant
        item = create :item, unit_price: 19.99, id: 1, merchant: merchant
        patch '/api/v1/items/1', params: { unit_price: 15.00 }
        item_resp = JSON.parse(response.body, symbolize_names: true)
        expect(item_resp[:data][:attributes][:name]).to eq(item.name)
        expect(item_resp[:data][:attributes][:description]).to eq(item.description)
        expect(item_resp[:data][:attributes][:unit_price]).to eq(15.00)
        expect(item_resp[:data][:attributes][:merchant_id]).to eq(merchant.id)
      end
    end
    describe 'Sad Path' do
      it 'finds no item' do
        item_1 = create :item, id: 1

        patch '/api/v1/items/50'
        item = JSON.parse(response.body, symbolize_names: true)
        expect(response.status).to eq(404)
        expect(item.count).to eq(1)
        expect(item).to be_a Hash
        expect(item[:data]).to eq([])
      end
    end
  end
  describe 'item delete' do
    describe 'Happy Path' do
      it 'can delete an item' do
        merchant = create :merchant
        item = create :item, id: 1, merchant: merchant
        delete '/api/v1/items/1'
        item_resp = JSON.parse(response.body, symbolize_names: true)

        expect(item_resp[:data][:attributes][:name]).to eq(item.name)
        expect(item_resp[:data][:attributes][:description]).to eq(item.description)
        expect(item_resp[:data][:attributes][:unit_price]).to eq(item.unit_price)
        expect(item_resp[:data][:attributes][:merchant_id]).to eq(merchant.id)
        expect(Item.count).to eq(0)
      end
      it 'can delete an invoice if the item being destroyed is the only one on the invoice' do
        merchant = create :merchant
        item = create :item, id: 1, merchant: merchant
        delete '/api/v1/items/1'
        item_resp = JSON.parse(response.body, symbolize_names: true)

        expect(item_resp[:data][:attributes][:name]).to eq(item.name)
        expect(item_resp[:data][:attributes][:description]).to eq(item.description)
        expect(item_resp[:data][:attributes][:unit_price]).to eq(item.unit_price)
        expect(item_resp[:data][:attributes][:merchant_id]).to eq(merchant.id)
        expect(Item.count).to eq(0)
      end
    end
    # describe 'Sad Path' do
    #   it 'cant find the item to delete' do
    #   end
    # end
  end
end
