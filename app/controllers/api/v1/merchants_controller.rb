class Api::V1::MerchantsController < ApplicationController

  def index
    if params[:page].nil? || params[:page].to_i <= 0
      page = 1
    else
      page = params.fetch(:page, 1).to_i
    end
    merchants = Merchant.limit(20).offset((page- 1) * 20)
    render json: MerchantSerializer.new(merchants)
  end
end
