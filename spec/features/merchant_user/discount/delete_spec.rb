require 'rails_helper'

RSpec.describe 'merchants discount edit page', type: :feature do
  describe 'As a merchant user' do
    it 'When I click on a link to update a specific discount, I am taken to a
    form where I can fill in the quantity and percent discount' do
      
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
      discount_1 = Discount.create(quantity: 10, percent_discount: 2)

      visit '/login'
      fill_in :email, with: 'Bob1234@hotmail.com'
      fill_in :password, with: 'heftybags'
      click_button 'Login'

      visit '/merchant/discount'

      click_link 'Delete Discount'

      expect(current_path).to eq('/merchant/discount')

      expect(page).to have_content('Discount Deleted')
      expect(page).not_to have_content("#{discount_1.id}: Quantity: 5 Percent Discount: 2.5")
    end
  end
end