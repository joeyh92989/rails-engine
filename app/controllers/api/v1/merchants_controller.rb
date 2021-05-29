class Api::V1::MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show]
  def index
    page = pages
    results_per_page = results_per_page_request
    if results_per_page >= Merchant.all.count
      render json: MerchantSerializer.new(Merchant.all)
    else
      merchants = Merchant.limit(results_per_page_request).offset((page - 1) * results_per_page_request)
      render json: MerchantSerializer.new(merchants)
    end
  end

  def show
    if @merchant.nil?
      render json: MerchantSerializer.new(Merchant.new), status: :not_found
    else
      render json: MerchantSerializer.new(@merchant)
    end
  end

  private

  def set_merchant
    @merchant = Merchant.find_by(id: params[:id])
  end
end
