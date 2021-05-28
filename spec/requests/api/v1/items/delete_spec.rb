require 'rails_helper'

describe 'Items' do
  describe 'item delete' do
    describe 'Happy Path' do
      it 'can delete an item' do
        merchant = create :merchant
        create :item, id: 1, merchant: merchant
        delete '/api/v1/items/1'
        expect(response.status).to eq(204)
        expect(Item.count).to eq(0)
      end
      it 'can delete an invoice if the item being destroyed is the only one on the invoice' do
        merchant = create :merchant
        item3 = create :item, merchant: merchant
        invoice2 = create :invoice, merchant: merchant
        create :invoice_item, item: item3, invoice: invoice2

        delete "/api/v1/items/#{item3.id}"
        expect(response.status).to eq(204)
        expect(Item.count).to eq(0)
        expect(Invoice.count).to eq(0)
      end
      it 'can will not delete an invoice if there are more items on it' do
        merchant = create :merchant
        item1 = create :item, merchant: merchant
        item2 = create :item, merchant: merchant
        invoice = create :invoice, merchant: merchant
        create :invoice_item, item: item1, invoice: invoice
        create :invoice_item, item: item2, invoice: invoice

        delete "/api/v1/items/#{item1.id}"
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
