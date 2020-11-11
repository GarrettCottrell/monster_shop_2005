# frozen_string_literal: true

class OrdersController < ApplicationController
  def new; end

  def create
    order_params[:user_id] = current_user.id
    order = Order.create(order_params.merge(user_id: current_user.id).merge(status: 'Pending'))
    if order.save
      cart.items.each do |item, quantity|
        if item.merchant.find_discount(quantity) != nil
        order.item_orders.create({ item: item,
                                   quantity: quantity,
                                   price: item.price,
                                   merchant_id: item.merchant.id,
                                   status: "Pending",
                                   discounted_price: cart.subtotal_with_discount(item, quantity),
                                   discounted_unit_price: item.discounted_unit_price(quantity)})
        elsif
          order.item_orders.create({ item: item,
                                   quantity: quantity,
                                   price: item.price,
                                   merchant_id: item.merchant.id,
                                   status: "Pending"})
        end
      end
      session.delete(:cart)
      redirect_to '/profile/orders', notice: 'Your order has been created'
    else
      flash[:notice] = 'Please complete address form to create an order.'
      render :new
    end
  end

  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip)
  end
end
