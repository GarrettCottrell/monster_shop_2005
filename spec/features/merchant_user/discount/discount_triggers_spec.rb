require 'rails_helper'

RSpec.describe 'discount triggers on adding items to cart', type: :feature do
  describe 'As a user' do
    it 'When I add sufficient quantity of an item to an order, the appropriate
    bulk discount for that item is reflected on the cart page and only 
    discounts from the appropritae merchant show up on the cart page' do

      print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
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
      discount_2 = print_shop.discounts.create(quantity: 4, percent_discount: 9)
      discount_3 = print_shop.discounts.create(quantity: 3, percent_discount: 8)
      discount_4 = print_shop.discounts.create(quantity: 2, percent_discount: 7)
      discount_5 = print_shop.discounts.create(quantity: 1, percent_discount: 2)
      discount_6 = bike_shop.discounts.create(quantity: 4, percent_discount: 43)
      @paper = print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 300, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 103, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      visit '/login'
      fill_in :email, with: 'Bob1234@hotmail.com'
      fill_in :password, with: 'heftybags'
      click_button 'Login'

      visit "/items/#{@paper.id}"
      click_on 'Add To Cart'
      visit "/items/#{@pencil.id}"
      click_on 'Add To Cart'
      visit "/items/#{@tire.id}"
      click_on 'Add To Cart'
      visit "/cart"
      within "#cart-item-#{@paper.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
      end
      within "#cart-item-#{@pencil.id}" do
        click_button "+"
        click_button "+"
      end
      within "#cart-item-#{@tire.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
      end
      within "#cart-item-#{@paper.id}" do
        expect(page).to have_content(discount_1.percent_discount)
        expect(page).to_not have_content(discount_6.percent_discount)
        expect(page).to_not have_content(discount_5.percent_discount)
        expect(page).to_not have_content(discount_4.percent_discount)
        expect(page).to_not have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
      end
      within "#cart-item-#{@pencil.id}" do
        expect(page).to have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_1.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
        expect(page).to_not have_content(discount_4.percent_discount)
        expect(page).to_not have_content(discount_5.percent_discount)
        expect(page).to_not have_content(discount_6.percent_discount)
      end
      within "#cart-item-#{@tire.id}" do
        expect(page).to have_content(discount_6.percent_discount)
        expect(page).to_not have_content(discount_5.percent_discount)
        expect(page).to_not have_content(discount_4.percent_discount)
        expect(page).to_not have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
        expect(page).to_not have_content(discount_1.percent_discount)
      end
    end

      it 'When I decrease the quantity of an item in an order below the
      discount threshhold, the appropriate discount is applied or no
      discount is applied, if quantity is now below all discount thresholds' do

      print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
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
      discount_2 = print_shop.discounts.create(quantity: 4, percent_discount: 9)
      discount_3 = print_shop.discounts.create(quantity: 3, percent_discount: 8)
      discount_4 = print_shop.discounts.create(quantity: 2, percent_discount: 7)
      discount_5 = print_shop.discounts.create(quantity: 1, percent_discount: 2)
      discount_6 = bike_shop.discounts.create(quantity: 4, percent_discount: 43)
      @paper = print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 300, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 103, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      visit '/login'
      fill_in :email, with: 'Bob1234@hotmail.com'
      fill_in :password, with: 'heftybags'
      click_button 'Login'

      visit "/items/#{@paper.id}"
      click_on 'Add To Cart'
      visit "/items/#{@pencil.id}"
      click_on 'Add To Cart'
      visit "/items/#{@tire.id}"
      click_on 'Add To Cart'
      visit "/cart"
      within "#cart-item-#{@paper.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
        click_button "+"
      end
      within "#cart-item-#{@pencil.id}" do
        click_button "+"
        click_button "+"
      end
      within "#cart-item-#{@tire.id}" do
        click_button "+"
        click_button "+"
        click_button "+"
      end
      within "#cart-item-#{@paper.id}" do
        click_button "-"
        click_button "-"
        expect(page).to have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_6.percent_discount)
        expect(page).to_not have_content(discount_5.percent_discount)
        expect(page).to_not have_content(discount_4.percent_discount)
        expect(page).to_not have_content(discount_1.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
      end
      within "#cart-item-#{@pencil.id}" do
        click_button "-"
        click_button "-"
        expect(page).to have_content(discount_5.percent_discount)
        expect(page).to_not have_content(discount_1.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
        expect(page).to_not have_content(discount_4.percent_discount)
        expect(page).to_not have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_6.percent_discount)
      end
      within "#cart-item-#{@tire.id}" do
        click_button "-"
        click_button "-"
        expect(page).to_not have_content(discount_6.percent_discount)
        expect(page).to_not have_content(discount_5.percent_discount)
        expect(page).to_not have_content(discount_4.percent_discount)
        expect(page).to_not have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
        expect(page).to_not have_content(discount_1.percent_discount)
      end
    end

    it "A discount is only applied to an item when that single item's
    quantity is above the discount threshhold of that merchants' discounts,
    regardless of how many total items are in the order" do

      print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
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
      discount_2 = print_shop.discounts.create(quantity: 4, percent_discount: 9)
      discount_3 = print_shop.discounts.create(quantity: 3, percent_discount: 8)
      discount_6 = print_shop.discounts.create(quantity: 6, percent_discount: 43)
      @paper = print_shop.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = print_shop.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 300, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @tire = print_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 103, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @bike = print_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 103, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @junk = print_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 103, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      visit '/login'
      fill_in :email, with: 'Bob1234@hotmail.com'
      fill_in :password, with: 'heftybags'
      click_button 'Login'

      visit "/items/#{@paper.id}"
      click_on 'Add To Cart'
      visit "/items/#{@pencil.id}"
      click_on 'Add To Cart'
      visit "/items/#{@tire.id}"
      click_on 'Add To Cart'
      visit "/items/#{@bike.id}"
      click_on 'Add To Cart'
      visit "/items/#{@junk.id}"
      click_on 'Add To Cart'
      
      visit '/cart'

      within "#cart-item-#{@paper.id}" do
        click_button "+"
      end
      within "#cart-item-#{@pencil.id}" do
        click_button "+"
      end
      within "#cart-item-#{@tire.id}" do
        click_button "+"
        click_button "+"
      end
      within "#cart-item-#{@paper.id}" do
        expect(page).to_not have_content(discount_1.percent_discount)
        expect(page).to_not have_content(discount_6.percent_discount)
        expect(page).to_not have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
      end
      within "#cart-item-#{@pencil.id}" do
        expect(page).to_not have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_1.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
        expect(page).to_not have_content(discount_6.percent_discount)
      end
      within "#cart-item-#{@tire.id}" do
        expect(page).to_not have_content(discount_6.percent_discount)
        expect(page).to have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
        expect(page).to_not have_content(discount_1.percent_discount)
      end
      within "#cart-item-#{@bike.id}" do
        expect(page).to_not have_content(discount_6.percent_discount)
        expect(page).to_not have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
        expect(page).to_not have_content(discount_1.percent_discount)
      end
      within "#cart-item-#{@junk.id}" do
        expect(page).to_not have_content(discount_6.percent_discount)
        expect(page).to_not have_content(discount_3.percent_discount)
        expect(page).to_not have_content(discount_2.percent_discount)
        expect(page).to_not have_content(discount_1.percent_discount)
      end
    end
  end
end
