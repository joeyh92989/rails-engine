class Invoice < ApplicationRecord
  validates :status, presence: true

  belongs_to :customer
  belongs_to :merchant
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items

  def self.invoices_sorted_by_rev(quantity)
    joins(:transactions, :invoice_items)
      .select('invoices.*, sum(invoice_items.quantity * invoice_items.unit_price) as total_revenue')
      .group(:id)
      .where('transactions.result = ?', 'success')
      .where('invoices.status = ?', 'packaged')
      .order('total_revenue desc')
      .limit(quantity)
  end

  def total_rev
    transactions.joins(invoice: :invoice_items)
                .where('transactions.result = ?', 'success')
                .where('invoices.status = ?', 'packaged')
                .sum('invoice_items.quantity * invoice_items.unit_price')
  end
end
