class Api::V1::MerchantsController < ApplicationController

  def index
    
    merchants_per_page = 20
    page = params.fetch(:page, 0).to_i
    render json: Merchant.limit(merchants_per_page).offset(page * merchants_per_page)

  end
end
