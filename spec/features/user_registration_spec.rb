require 'rails_helper'

RSpec.feature 'UserRegistrations', type: :feature do
  scenario 'User can sign up' do
    visit new_user_path

    fill_in 'Name', with: 'John Doe'
    fill_in 'Email', with: 'john@example.com'
    fill_in 'Password', with: 'Password123!'
    fill_in 'Phone', with: '1234567890'

    click_button 'Sign up'

    expect(page).to have_content 'Please log in to access this page.'
  end

  scenario 'User cannot sign up with invalid data' do
    visit new_user_path

    fill_in 'Name', with: ''
    fill_in 'Email', with: 'invalid_email'
    fill_in 'Password', with: ''
    fill_in 'Phone', with: '1234567890'

    click_button 'Sign up'

    expect(page).to have_content 'Sign up'
  end
end
