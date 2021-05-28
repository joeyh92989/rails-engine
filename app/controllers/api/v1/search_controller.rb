class Api::V1::SearchController < ApplicationController
  def item_search
    binding.pry
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

