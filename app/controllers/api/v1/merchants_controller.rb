class Api::V1::MerchantsController < ApplicationController
  def index
    render json: Merchant.all.limit(20)
  end
end
