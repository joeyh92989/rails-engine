require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to have_many(:invoice_items).dependent(:destroy) }
    it { is_expected.to have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:status) }
  end
end
