require 'rails_helper'

RSpec.feature "CarManagement", type: :feature do
  let!(:user) { create(:user) }
  let!(:car) { create(:car, user:) }

  before do
    visit login_path
    fill_in 'Email', with: 'john.doe@example.com'
    fill_in 'Password', with: 'Password123!'
    click_button 'Log in'
  end

  scenario 'User can create a new car' do
    visit new_car_path

    fill_in 'Brand', with: 'Honda'
    fill_in 'Car model', with: 'Accord'
    fill_in 'Body', with: 'Sedan'
    fill_in 'Mileage', with: 5000
    fill_in 'Color', with: 'White'
    fill_in 'Price', with: 25000
    fill_in 'Fuel', with: 'Gasoline'
    fill_in 'Year', with: 2022
    fill_in 'Volume', with: 2.0

    click_button 'Save'

    expect(page).to have_content 'Car was successfully created.'
    expect(page).to have_content 'Honda'
    expect(page).to have_content 'Accord'
  end

  scenario 'User can view a car' do
    visit car_path(car)

    expect(page).to have_content 'Toyota'
    expect(page).to have_content 'Corolla'
  end

  scenario 'User can edit a car' do
    visit edit_car_path(car)

    fill_in 'Brand', with: 'Nissan'
    fill_in 'Car model', with: 'Altima'
    fill_in 'Mileage', with: 8000

    click_button 'Save'

    expect(page).to have_content 'Car was successfully updated.'
    expect(page).to have_content 'Nissan'
    expect(page).to have_content 'Altima'
  end
end
