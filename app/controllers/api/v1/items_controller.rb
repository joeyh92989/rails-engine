class Api::V1::ItemsController < ApplicationController
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
    if results_per_page >= Item.all.count
      render json: ItemSerializer.new(Item.all)
    else
      items = Item.limit(results_per_page).offset((page - 1) * results_per_page)
      render json: ItemSerializer.new(items)
    end
  end

  def show
    if Item.where(id: params[:id]) == []
      item= []
      render json: ItemSerializer.new(item), status: :not_found
    else
      item= Item.find(params[:id])
      render json: ItemSerializer.new(item)
    end

  end
end