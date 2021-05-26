require 'rails_helper'

describe 'Items' do
  describe 'item delete' do
    describe 'Happy Path' do
      it 'can delete an item' do
        merchant = create :merchant
        item = create :item, id: 1, merchant: merchant
        delete '/api/v1/items/1'
        expect(response.status).to eq(204)
        expect(Item.count).to eq(0)
      end
      it 'can delete an invoice if the item being destroyed is the only one on the invoice' do
        merchant = create :merchant
        item_3 = create :item, merchant: merchant
        invoice_2 = create :invoice, merchant: merchant
        invoice_item_3 = create :invoice_item, item: item_3, invoice: invoice_2

        delete "/api/v1/items/#{item_3.id}"
        expect(response.status).to eq(204)
        expect(Item.count).to eq(0)
        expect(Invoice.count).to eq(0)
      end
      it 'can will not delete an invoice if there are more items on it' do
        merchant = create :merchant
        item_1 = create :item, merchant: merchant
        item_2 = create :item, merchant: merchant
        invoice_1 = create :invoice, merchant: merchant
        invoice_item_1 = create :invoice_item, item: item_1, invoice: invoice_1
        invoice_item_2 = create :invoice_item, item: item_2, invoice: invoice_1

        delete "/api/v1/items/#{item_1.id}"
        expect(response.status).to eq(204)
        expect(Item.count).to eq(1)
        expect(Invoice.count).to eq(1)
      end
    end
    describe 'Sad Path' do
      it 'cant find the item to delete' do
        delete '/api/v1/items/20'
        expect(response.status).to eq(404)
      end
    end
  end
end
