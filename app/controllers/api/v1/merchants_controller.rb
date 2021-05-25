class Api::V1::MerchantsController < ApplicationController
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
    merchants = Merchant.limit(results_per_page).offset((page - 1) * results_per_page)
    render json: MerchantSerializer.new(merchants)
  end
end
