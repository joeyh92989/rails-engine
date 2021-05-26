class Api::V1::Items::ItemMerchantsController < ApplicationController
  def index
    if Item.where(id: params[:id]) == []
      item = []
      render json: ItemSerializer.new(item), status: :not_found
    else
      item = Item.find(params[:id])
      merchant = item.merchant
      render json: MerchantSerializer.new(merchant)
    end
  end
end
