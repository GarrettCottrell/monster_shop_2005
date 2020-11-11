# frozen_string_literal: true

class ProfileOrdersController < ApplicationController
  def index; end

  def show
    @order = Order.find(params[:id])
  end

  def cancel
    order = Order.find(params[:id])
    order.cancel_order(order.id)
    flash[:notice] = 'Your order is now cancelled'
    redirect_to profile_orders_path
  end
end
