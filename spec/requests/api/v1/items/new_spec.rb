require 'rails_helper'

describe 'Items' do
  describe 'item create' do
    describe 'Happy Path' do
      it 'creates a new item and returns it as a response' do
        merchant = create :merchant
        post '/api/v1/items',
             params: { item: { name: 'test', description: 'lorem ipsum', unit_price: 19.50, merchant_id: merchant.id } }

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
      it 'returns a fail when user enters no name' do
        merchant = create :merchant
        post '/api/v1/items',
             params: { item: { description: 'lorem ipsum', unit_price: 19.50, merchant_id: merchant.id } }

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item[:errors]).to be_a(Array)
        expect(response.status).to eq(400)
      end
      it 'returns a fail when user enters no description' do
        merchant = create :merchant
        post '/api/v1/items',
             params: { item: { name: 'test', unit_price: 19.50, merchant_id: merchant.id } }

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item[:errors]).to be_a(Array)
        expect(response.status).to eq(400)
      end
      it 'returns a fail when user enters no unit price' do
        merchant = create :merchant
        post '/api/v1/items',
             params: { item: { name: 'test', description: 'lorem ipsum', merchant_id: merchant.id } }

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item[:errors]).to be_a(Array)
        expect(response.status).to eq(400)
      end
      it 'returns a fail when user enters no merchant id' do
        create :merchant
        post '/api/v1/items',
             params: { item: { name: 'test', description: 'lorem ipsum', unit_price: 19.50 } }

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item[:errors]).to be_a(Array)
        expect(response.status).to eq(400)
      end
      it 'returns a fail when user enters a merchant id that is not in the system' do
        create :merchant
        post '/api/v1/items',
             params: { item: { name: 'test', description: 'lorem ipsum', unit_price: 19.50, merchant_id: 20 } }

        item = JSON.parse(response.body, symbolize_names: true)
        expect(item[:errors]).to be_a(Array)
        expect(response.status).to eq(400)
      end
    end
  end
end
