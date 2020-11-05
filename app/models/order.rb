# frozen_string_literal: true

class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders
  belongs_to :user

  def grandtotal
    item_orders.sum('price * quantity')
  end

  def count_items
    items.count
  end

  def return_items
    item_orders.each do |item_order|
      inventory = item_order.item.inventory
      inventory += item_order.quantity
      item_order.item.update!(inventory: inventory)
    end
  end

  def item_qty(merchant_id)
    self.item_orders.where('merchant_id = ?', merchant_id).sum(:quantity)
  end

  def total_value(merchant_id)
    self.item_orders.where('merchant_id = ?', merchant_id).sum('quantity * price')
  end

  def items_by_merchant(merchant_id)
    self.items.where('item_orders.merchant_id = ?', merchant_id)
  end

  def cancel_order
    self.update(status: 'cancelled')
    self.return_items
    self.item_orders.update(status: 'unfulfilled')
  end
end
