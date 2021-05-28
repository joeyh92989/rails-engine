class Merchant < ApplicationRecord
  validates :name, presence: true

  has_many :items, dependent: :destroy
  has_many :invoices, dependent: :destroy
  has_many :transactions, through: :invoices
  has_many :invoice_items, through: :invoices
  def self.merchants_ordered_by_rev(quantity)
    joins(invoices: %i[transactions invoice_items])
      .select('merchants.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
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
  def self.find_all_by_name(name)
    where('lower(name) LIKE :search', search: "%#{name.downcase}%")
      .order(:name)
  end
end
