require 'rails_helper'

describe 'Items' do
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
end
