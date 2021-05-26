require 'rails_helper'

describe 'Items' do
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
end
