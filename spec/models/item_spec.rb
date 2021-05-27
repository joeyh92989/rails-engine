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
    it 'can return any invoice where it is the only item on the invoice' do
      merchant = create :merchant
      item1 = create :item, merchant: merchant
      item2 = create :item, merchant: merchant
      item3 = create :item, merchant: merchant
      invoice1 = create :invoice, merchant: merchant
      invoice2 = create :invoice, merchant: merchant
      create :invoice_item, item: item1, invoice: invoice1
      create :invoice_item, item: item2, invoice: invoice1
      create :invoice_item, item: item3, invoice: invoice2
      expect(item1.lone_invoice).to eq([])
      expect(item3.lone_invoice).to eq([invoice2])
    end
  end
end
