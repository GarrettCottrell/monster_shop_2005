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

  def edit
    @merchant = Merchant.find(params[:merchants_id])
    @discount = Discount.find(params[:discount_id])
  end

  def update
    discount = Discount.find(discount_id_params[:discount_id])
    discount.assign_attributes(discount_params)
    if discount.save 
      flash[:notice] = 'Discount Updated'
      redirect_to "/merchants/#{params[:merchant_id]}/discount"
    end
  end

  def destroy
    discount = Discount.find(params[:discount_id])
    discount.destroy
    redirect_to "/merchants/#{params[:merchant_id]}/discount"
    flash[:notice] = 'Discount Deleted'
  end

  private

  def discount_params
    params.require(:discount).permit(:quantity, :percent_discount)
  end

  def discount_id_params 
    params.require(:discount).permit(:discount_id)
  end
end
