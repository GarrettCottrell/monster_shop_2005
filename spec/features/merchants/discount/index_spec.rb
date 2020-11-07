require 'rails_helper'

RSpec.describe 'merchants discount index page', type: :feature do
  describe 'As a merchant user' do
    it 'I can see all the discounts for the merchant and I can see a link
    to create/update/delete each discount' do
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
      save_and_open_page
      expect(page).to have_content('New discount has been created')
      expect(page).to have_content("#{Discount.last.id}: Quantity: 20 Percent Discount: 5")
      expect(page).to have_link("Create Discount")
      expect(page).to have_link("Update Discount")
      expect(page).to have_link("Delete Discount")
    end
  end
end
