class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[show update destroy]
  before_action :set_merchant, only: %i[create]
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
    if @item.nil?
      render json: ItemSerializer.new(Item.new), status: :not_found
    else
      render json: ItemSerializer.new(@item)
    end
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: { errors: item.errors.full_messages }, status: :bad_request
    end
  end

  def update
    if @item.nil?
      render json: ItemSerializer.new(Item.new), status: :not_found
    elsif Merchant.find_by(id: params[:item][:merchant_id]).nil? && params[:item].key?(:merchant_id)
      render json: { errors: 'Merchant not found' }, status: :not_found
    else
      @item.update(item_params)
      render json: ItemSerializer.new(@item)
    end
  end

  def destroy
    if @item.nil?

      render json: ItemSerializer.new(Item.new), status: :not_found
    else
      invoices = @item.lone_invoice
      @item.destroy
      invoices.each(&:destroy)
    end
  end

  private

  def set_item
    @item = Item.find_by(id: params[:id])
  end

  def set_merchant
    @merchant = if !@item.nil?
                  Merchant.find_by(id: @item.merchant_id)
                elsif !params[:item].nil?
                  Merchant.find_by(id: params[:item][:merchant_id])
                end
  end

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id)
  end
end
