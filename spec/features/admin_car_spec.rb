require 'rails_helper'

RSpec.feature 'AdminCarManagement', type: :feature do
  let!(:user) { create(:user) }
  let!(:car) { create(:car, user:) }

  let!(:admin) { User.create(name: 'Admin', email: 'admin@example.com', password: 'Password123!', role: 'admin') }

  before do
    visit admin_login_path
    fill_in 'Email', with: 'admin@example.com'
    fill_in 'Password', with: 'Password123!'
    click_button 'Log in'
  end

  scenario 'Admin can view list of cars' do
    visit admin_cars_path

    expect(page).to have_content 'Cars'
    expect(page).to have_content car.brand
    expect(page).to have_content car.car_model
  end

  scenario 'Admin can view a car' do
    visit admin_car_path(car)

    expect(page).to have_content 'Toyota'
    expect(page).to have_content 'Corolla'
  end

  scenario 'Admin can edit a car status' do
    visit edit_admin_car_path(car)

    select 'approved', from: 'Status'
    click_button 'Update Status'

    expect(page).to have_content 'Car status was successfully updated.'
  end
end
