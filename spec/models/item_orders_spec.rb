# frozen_string_literal: true

require 'rails_helper'

describe ItemOrder, type: :model do
  describe 'validations' do
    it { should validate_presence_of :order_id }
    it { should validate_presence_of :item_id }
    it { should validate_presence_of :price }
    it { should validate_presence_of :quantity }
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :order }
    it { should belong_to :merchant }
  end

  describe 'instance methods' do
    it '#subtotal' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      user = User.create(
        name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'JBob1234@hotmail.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 0
      )
      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, user_id: user.id)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, merchant_id: meg.id)

      expect(item_order_1.subtotal).to eq(200)
    end
    it '#items_left' do
      meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      user = User.create(
        name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'JBob1234@hotmail.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 0
      )
      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, user_id: user.id)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2, merchant_id: meg.id)

      expect(item_order_1.items_left).to eq(10)
    end

    it "#discount" do
      bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      user = User.create!(
        name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'J1234@hotmail.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 0
      )
      discount_1 = bike_shop.discounts.create(quantity: 10, percent_discount: 2)
      discount_2 = bike_shop.discounts.create(quantity: 20, percent_discount: 5)
      discount_3 = bike_shop.discounts.create(quantity: 30, percent_discount: 10)
      discount_4 = bike_shop.discounts.create(quantity: 40, percent_discount: 20)
      discount_5 = bike_shop.discounts.create(quantity: 50, percent_discount: 30)

      chain = bike_shop.items.create(name: 'Chain', description: "It'll never break!", price: 50, image: 'https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588', inventory: 5)
      tire = bike_shop.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      rack = bike_shop.items.create(name: 'Bike Rack', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      order_1 = Order.create!(name: 'JakeBob', address: '123 Stang St', city: 'Hershey', state: 'PA', zip: 80_218, user_id: user.id, status: 'Pending')
      order_item_1 = order_1.item_orders.create!(item: chain, price: chain.price, quantity: 60, status: 'Pending', merchant_id: bike_shop.id)
      order_item_2 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 40, status: 'Pending', merchant_id: bike_shop.id)
      order_item_3 = order_1.item_orders.create!(item: rack, price: rack.price, quantity: 30, status: 'Pending', merchant_id: bike_shop.id)
      order_item_4 = order_1.item_orders.create!(item: rack, price: rack.price, quantity: 20, status: 'Pending', merchant_id: bike_shop.id)
      order_item_5 = order_1.item_orders.create!(item: rack, price: rack.price, quantity: 10, status: 'Pending', merchant_id: bike_shop.id)

      expect(order_item_1.discount(chain.order_item(order_1.id).quantity)).to eq(discount_5.percent_discount / 100)
    end
  end
end
