require 'rails_helper'

RSpec.describe 'merchants discount new page', type: :feature do
  describe 'As a merchant user' do
    it 'I can create a new discount and upon successful creation, I am 
    redirected to the discounts index page with a flash message that the 
    discount was successfully created' do
      print_shop = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      merchant_user = print_shop.users.create!(name: 'JakeBob',
        address: '124 Main St',
        city: 'Denver',
        state: 'Colorado',
        zip: '80202',
        email: 'Bob1234@hotmail.com',
        password: 'heftybags',
        password_confirmation: 'heftybags',
        role: 1
      )

      visit '/login'
      fill_in :email, with: 'Bob1234@hotmail.com'
      fill_in :password, with: 'heftybags'
      click_button 'Login'

      visit "/merchants/#{print_shop.id}/discount"
      click_link "Create Discount"
      expect(current_path).to eq("/merchants/#{print_shop.id}/discount/new")
      fill_in :discount_quantity, with: 20
      fill_in :discount_percent_discount, with: 5

      click_button 'Create Discount'

      expect(current_path).to eq("/merchants/#{print_shop.id}/discount")
      expect(page).to have_content("New discount has been created")
    end
  end
end
