class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items, dependent: :destroy
  has_many :invoices
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  def self.merchants_ordered_by_rev
      joins(invoices: [:transactions, :invoice_items])
      .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
      .group(:id)
      .where('transactions.result = ?', "success" )
      .where('invoices.status = ?', "shipped")
      .order('total_revenue desc')
  end
  def total_rev
    invoices.joins(:invoice_items, :transactions)
    .where('transactions.result = ?', "success" )
    .where('invoices.status = ?', "shipped")
    .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end

