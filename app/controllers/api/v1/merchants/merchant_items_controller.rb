class Api::V1::Merchants::MerchantItemsController < ApplicationController
  def index
    if Merchant.where(id: params[:id]) == []
      merchant = []
      render json: MerchantSerializer.new(merchant), status: :not_found
    else
      merchant = Merchant.find(params[:id])
      items = merchant.items
      render json: ItemSerializer.new(items)
    end
  end
end
