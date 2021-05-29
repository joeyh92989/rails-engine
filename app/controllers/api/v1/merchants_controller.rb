class Api::V1::MerchantsController < ApplicationController
  before_action :set_merchant, only: [:show]
  def index
    page = if params[:page].nil? || params[:page].to_i <= 0
             1
           else
             params.fetch(:page, 1).to_i
           end
    results_per_page = if params[:per_page].nil? || params[:per_page].to_i <= 0
                         20
                       else
                         params[:per_page].to_i
                       end
    if results_per_page >= Merchant.all.count
      render json: MerchantSerializer.new(Merchant.all)
    else
      merchants = Merchant.limit(results_per_page).offset((page - 1) * results_per_page)
      render json: MerchantSerializer.new(merchants)
    end
  end

  def show
    if @merchant == nil
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
