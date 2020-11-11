class Item <ApplicationRecord
  belongs_to :merchant
  has_many :reviews, dependent: :destroy
  has_many :item_orders
  has_many :orders, through: :item_orders

  validates_presence_of :name,
                        :description,
                        :price,
                        :inventory
  validates_inclusion_of :active?, :in => [true, false]
  validates_numericality_of :price, greater_than: 0
  validates_numericality_of :inventory, greater_than_or_equal_to: 0


  def average_review
    reviews.average(:rating)
  end

  def sorted_reviews(limit, order)
    reviews.order(rating: order).limit(limit)
  end

  def no_orders?
    item_orders.empty?
  end

  def self.find_enabled_items
    Item.where(active?: true)
  end

  def self.top_five
    Item.joins(:item_orders).select('items.name, item_orders.quantity').order('quantity desc').limit(5)
  end

  def self.bottom_five
    Item.joins(:item_orders).select('items.name, item_orders.quantity').order('quantity asc').limit(5)
  end

  def order_quantity(order_id)
    self.item_orders.where('order_id =?', order_id).sum(:quantity)
  end

  def status(order_id)
    self.item_orders.find_by('order_id =?', order_id).status
  end

  def order_item_id(order_id)
    self.item_orders.find_by('order_id =?', order_id).id
  end

  def order_item(order_id)
    self.item_orders.find_by('order_id =?', order_id)
  end

  def total_cost(order_id)
    order_item(order_id).quantity * price
  end

  def item_discount(quantity)
    merchant.find_discount_amount(quantity) / 100
  end

  def discounted_unit_price(quantity)
    price - (price * item_discount(quantity))
  end
end
