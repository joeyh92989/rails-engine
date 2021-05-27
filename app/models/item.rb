class Item < ApplicationRecord
  validates :name, :description, :unit_price, :merchant_id, presence: true
  validates :unit_price, numericality: true

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  has_many :transactions, through: :invoices
  def lone_invoice
    invoices.find_all { |invoice| invoice.items.count == 1 }
  end

  def self.items_sorted_by_rev(quantity)
    joins(invoices: %i[transactions invoice_items])
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
      .group(:id)
      .where('transactions.result = ?', 'success')
      .where('invoices.status = ?', 'shipped')
      .order('total_revenue desc')
      .limit(quantity)
  end

  def total_rev
    invoices.joins(:invoice_items, :transactions)
            .where('transactions.result = ?', 'success')
            .where('invoices.status = ?', 'shipped')
            .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
