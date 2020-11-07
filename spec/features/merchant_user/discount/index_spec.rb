require 'rails_helper'

RSpec.describe 'merchants discount index page', type: :feature do
  describe 'As a merchant user' do
    it 'I can see all the discounts for the merchant and I can see a link
    to create a new discount, as well as update/delete each discount' do
      
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
      discount_1 = print_shop.discounts.create(quantity: 10, percent_discount: 2)
      discount_2 = print_shop.discounts.create(quantity: 20, percent_discount: 5)
      discount_3 = print_shop.discounts.create(quantity: 30, percent_discount: 10)


      visit '/login'
      fill_in :email, with: 'Bob1234@hotmail.com'
      fill_in :password, with: 'heftybags'
      click_button 'Login'

      visit "/merchant/discount"

      expect(page).to have_content("#{discount_1.id}: Quantity: 10 Percent Discount: 2")
      expect(page).to have_content("#{discount_2.id}: Quantity: 20 Percent Discount: 5")
      expect(page).to have_content("#{discount_3.id}: Quantity: 30 Percent Discount: 10")
      expect(page).to have_link('Create Discount')
      expect(page).to have_link('Update Discount')
      expect(page).to have_link('Delete Discount')
    end
  end
end
