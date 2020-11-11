class AddDiscountedUnitPriceToItemOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :item_orders, :discounted_unit_price, :float
  end
end
