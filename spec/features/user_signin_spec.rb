require 'rails_helper'

RSpec.feature "UserSignin", type: :feature do
  let!(:user) { create(:user) }

  scenario 'User can sign in' do
    visit login_path

    fill_in 'Email', with: 'john.doe@example.com'
    fill_in 'Password', with: 'Password123!'

    click_button 'Log in'

    expect(page).to have_content 'Logged in successfully'
  end

  scenario 'User cannot sign in with invalid data' do
    visit login_path

    fill_in 'Email', with: 'invalid_email'
    fill_in 'Password', with: ''

    click_button 'Log in'

    expect(page).to have_content "Forgot your password?"
  end
end
