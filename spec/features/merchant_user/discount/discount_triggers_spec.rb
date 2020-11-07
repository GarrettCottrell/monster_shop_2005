require 'rails_helper'

RSpec.describe 'discount triggers on adding items to cart', type: :feature do
  describe 'As a user' do
    it 'When I add sufficient quantity of an item to an order, the appropriate
    bulk discount for that item is reflected on the cart page' do

      print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      regular_user = print_shop.users.create!(name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'Bob1234@hotmail.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 0
      )
      discount_1 = print_shop.discounts.create(quantity: 5, percent_discount: 10)
      @paper = print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)

      visit '/login'
      fill_in :email, with: 'Bob1234@hotmail.com'
      fill_in :password, with: 'heftybags'
      click_button 'Login'

      visit "/items/#{@paper.id}"
      click_on 'Add To Cart'
      visit "/cart"
      click_button "+"
      click_button "+"
      click_button "+"
      click_button "+"
    end
  end
end
