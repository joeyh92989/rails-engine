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
  def self.find_by_name(name)
    where('lower(name) LIKE :search', search: "%#{name.downcase}%").first
  end

  def self.find_by_price(min, max)
    where("items.unit_price >= #{min} AND items.unit_price <= #{max}").order(:name).first
  end

  def self.find_by_price_max(max)
    where("items.unit_price <= #{max}").order(:name).first
  end

  def self.find_by_price_min(min)
    where("items.unit_price >= #{min}").order(:name).first
  end
end
