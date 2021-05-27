require 'rails_helper'

describe 'Revenue' do
  describe 'merchants ordered by total revenue' do
    describe 'Happy Path' do
      it "returns merchant revenue objects" do
        merchant_1 = create :merchant
        merchant_2 = create :merchant
        merchant_3 = create :merchant

# HINT: Invoices must have a successful transaction and be shipped to the customer to be considered as revenue.


        get '/api/v1/revenue/merchants?quantity = 3'
      end
    end

  end
end 
    