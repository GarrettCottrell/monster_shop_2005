class Merchant::DiscountController < Merchant::BaseController
  def new
    @discount = Discount.new
  end

  def index; end

  def create
    @discount = Discount.new(discount_params)
    if @discount.save
      redirect_to "/merchant/discount"
      flash[:notice] = "New discount has been created"
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    discount = Discount.find(discount_id_params[:discount_id])
    discount.assign_attributes(discount_params)
    if discount.save 
      flash[:notice] = 'Discount Updated'
      redirect_to '/merchant/discount'
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    redirect_to '/merchant/discount'
    flash[:notice] = 'Discount Deleted'
  end

  private

  def discount_params
    params.require(:discount).permit(:quantity, :percent_discount, :merchant_id)
  end

  def discount_id_params 
    params.require(:discount).permit(:discount_id)
  end
end
