class Api::V1::RevenueController < ApplicationController
  def merchants_order_by_rev
    quantity = params[:quantity].to_i

    if quantity.positive?
      merchants = Merchant.merchants_ordered_by_rev(params[:quantity])
      render json: MerchantNameRevenueSerializer.new(merchants)
    else
      render json: { errors: 'Must include quantity as an integer' }, status: :bad_request
    end
  end
end
