class Api::V1::SearchController < ApplicationController
  def item_search
    if params.key?(:name)
      item = Item.find_by_name(params[:name])
      if item.nil?
        render json: ItemSerializer.new(item), status: :not_found
      else
        render json: ItemSerializer.new(item)
      end
    elsif params.key?(:max_price) && params.key?(:min_price)

      item = Item.find_by_price(params[:min_price], params[:max_price])
      if item.nil?
        render json: ItemSerializer.new(item), status: :not_found
      else
        render json: ItemSerializer.new(item)
      end
    elsif params.key?(:max_price)

      item = Item.find_by_price_max(params[:max_price])
      if item.nil?
        render json: ItemSerializer.new(item), status: :not_found
      else
        render json: ItemSerializer.new(item)
      end
    elsif params.key?(:min_price)
      item = Item.find_by_price_max(params[:min_price])
      if item.nil?
        render json: ItemSerializer.new(item), status: :not_found
      else
        render json: ItemSerializer.new(item)
      end
    else
      render json: { errors: 'search params incorrect' }, status: :bad_request
    end
  end

  def merchant_search
    merchants = Merchant.find_all_by_name(params[:name])
    if merchants.count > 0
      render json: MerchantSerializer.new(merchants)
    else
      render json: MerchantSerializer.new(merchants), status: :not_found
    end
  end
end