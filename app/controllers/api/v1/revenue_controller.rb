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

  def merchant_rev
    if Merchant.where(id: params[:id]) == []
      merchant = []
      render json: MerchantRevenueSerializer.new(merchant), status: :not_found
    else
      merchant = Merchant.find(params[:id])
      render json: MerchantRevenueSerializer.new(merchant)
    end
  end
  def items_order_by_rev
    params[:quantity] = 10 unless params[:quantity].present?
    quantity = params[:quantity].to_i

    if quantity.positive?
      items = Item.items_sorted_by_rev(params[:quantity])
      render json: ItemRevenueSerializer.new(items)
    else
      render json: { errors: 'Must include quantity as an integer' }, status: :bad_request
    end
  end
end
