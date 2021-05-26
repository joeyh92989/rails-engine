class Item < ApplicationRecord
  validates :name, :description, :unit_price, :merchant_id, presence: true
  validates :unit_price, numericality: true

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  def lone_invoice
    self.invoices.find_all { |invoice| invoice.items.count == 1 }
  end
end
