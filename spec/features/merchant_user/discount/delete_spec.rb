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
      discount_1 = print_shop.discounts.create(quantity: 10, percent_discount: 5)
      discount_2 = print_shop.discounts.create(quantity: 15, percent_discount: 10)
      discount_3 = print_shop.discounts.create(quantity: 20, percent_discount: 15)
      discount_4 = print_shop.discounts.create(quantity: 25, percent_discount: 20)

      visit '/login'
      fill_in :email, with: 'Bob1234@hotmail.com'
      fill_in :password, with: 'heftybags'
      click_button 'Login'

      visit '/merchant/discount'

      expect(current_path).to eq('/merchant/discount')
      expect(page).to have_content("Discount ID #: #{discount_1.id} Quantity: #{discount_1.quantity} Percent Discount: #{discount_1.percent_discount}")
      expect(page).to have_link("Update Discount - ID: #{discount_1.id}")
      click_link "Delete Discount - ID: #{discount_1.id}"
      expect(page).to have_content('Discount Deleted')
      expect(page).not_to have_content("#{discount_1.id}: Quantity: 5 Percent Discount: 2.5")
      expect(page).to have_content("Discount ID #: #{discount_2.id} Quantity: #{discount_2.quantity} Percent Discount: #{discount_2.percent_discount}")
      expect(page).to have_link("Update Discount - ID: #{discount_2.id}")
      click_link "Delete Discount - ID: #{discount_2.id}"
      expect(page).to have_content('Discount Deleted')
      expect(page).not_to have_content("#{discount_2.id}: Quantity: 5 Percent Discount: 2.5")
      expect(page).to have_content("Discount ID #: #{discount_3.id} Quantity: #{discount_3.quantity} Percent Discount: #{discount_3.percent_discount}")
      expect(page).to have_link("Update Discount - ID: #{discount_3.id}")
      click_link "Delete Discount - ID: #{discount_3.id}"
      expect(page).to have_content('Discount Deleted')
      expect(page).not_to have_content("#{discount_3.id}: Quantity: 5 Percent Discount: 2.5")
      expect(page).to have_content("Discount ID #: #{discount_4.id} Quantity: #{discount_4.quantity} Percent Discount: #{discount_4.percent_discount}")
      expect(page).to have_link("Update Discount - ID: #{discount_4.id}")
      click_link "Delete Discount - ID: #{discount_4.id}"
      expect(page).to have_content('Discount Deleted')
      expect(page).not_to have_content("#{discount_4.id}: Quantity: 5 Percent Discount: 2.5")
    end
  end
end