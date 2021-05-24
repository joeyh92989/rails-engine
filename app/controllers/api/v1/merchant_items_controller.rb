class Api::V1::MerchantItemsController < ApplicationController
  def index
    render json: Book.all
  end

  
end
