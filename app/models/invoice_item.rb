class InvoiceItem < ApplicationRecord
  validates :quantity, :unit_price, presence: true
  validates :quantity, :unit_price, numericality: true

  belongs_to :invoice
  belongs_to :item
end
