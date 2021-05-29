class Api::V1::SearchController < ApplicationController
  def item_search
    if params.key?(:name) && !params.key?(:min_price) && !params.key?(:max_price)
      name_search
    elsif params.key?(:max_price) && params.key?(:min_price)
      max_min_search
    elsif params.key?(:max_price) && params[:max_price].to_f.positive?
      max_search
    elsif params.key?(:min_price) && params[:min_price].to_f.positive?
      min_seach
    else
      render json: { error: 'search params incorrect' }, status: :bad_request
    end
  end

  def name_search
    item = Item.find_by_name(params[:name])
    if item.nil?
      render json: ItemSerializer.new(Item.new), status: :not_found
    else
      render json: ItemSerializer.new(item)
    end
  end

  def max_min_search
    item = Item.find_by_price(params[:min_price], params[:max_price])
    if item.nil?
      render json: ItemSerializer.new(Item.new), status: :not_found
    else
      render json: ItemSerializer.new(item)
    end
  end

  def max_search
    item = Item.find_by_price_max(params[:max_price])
    if item.nil?
      render json: ItemSerializer.new(Item.new), status: :not_found
    else
      render json: ItemSerializer.new(item)
    end
  end

  def min_seach
    item = Item.find_by_price_min(params[:min_price])

    if item.nil?
      render json: ItemSerializer.new(Item.new), status: :not_found

    else
      render json: ItemSerializer.new(item)
    end
  end

  def merchant_search
    merchants = Merchant.find_all_by_name(params[:name])
    if merchants.count.positive?
      render json: MerchantSerializer.new(merchants)
    else
      render json: MerchantSerializer.new(merchants), status: :not_found
    end
  end
end
