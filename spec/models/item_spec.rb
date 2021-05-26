require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to have_many(:invoice_items).dependent(:destroy) }
    it { is_expected.to have_many(:invoices).through(:invoice_items) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:merchant_id) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_numericality_of(:unit_price) }
  end
  describe 'instance methods' do
    it "can return any invoice where it is the only item on the invoice" do
      #item.invoices
      # collectiion.find_all{|invoice| invoice.items.count == 1}
      merchant = create :merchant
      item_1= create :item, merchant: merchant
      item_2= create :item, merchant: merchant
      item_3= create :item, merchant: merchant
      invoice_1 = create :invoice, merchant: merchant
      invoice_2= create :invoice, merchant: merchant
      invoice_item_1 = create :invoice_item, item: item_1, invoice: invoice_1
      invoice_item_2 = create :invoice_item, item: item_2, invoice: invoice_1
      invoice_item_3 = create :invoice_item, item: item_3, invoice: invoice_2
      expect(item_1.lone_invoice).to eq([])
      expect(item_3.lone_invoice).to eq([invoice_2])
    end
  end
end
