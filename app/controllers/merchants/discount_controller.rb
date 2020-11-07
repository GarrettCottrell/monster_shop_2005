class Merchants::DiscountController < ApplicationController
  def new
    @merchant = Merchant.find(params[:merchants_id])
    @discount = Discount.new
  end

  def index
    @merchant = Merchant.find(params[:merchants_id])
  end

  def create
    @discount = Discount.new(discount_params)
    if @discount.save
      redirect_to "/merchants/#{params[:merchants_id]}/discount"
      flash[:notice] = "New discount has been created"
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:quantity, :percent_discount)
  end
end
