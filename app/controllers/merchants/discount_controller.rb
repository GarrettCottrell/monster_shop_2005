class Merchants::DiscountController < ApplicationController
  def new
    @merchant = Merchant.find(params[:merchants_id])
    @discount = Discount.new
  end

  def index
    @merchant = Merchant.find(params[:merchants_id])
  end
end
