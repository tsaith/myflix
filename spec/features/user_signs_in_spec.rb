require 'spec_helper'

feature "User signs in" do

  scenario "with valid email and password" do
    alice = Fabricate(:user)
    visit sign_in_path
    fill_in 'Email', :with => alice.email
    fill_in 'Password', :with => alice.password
    click_button 'Sign in'
    expect(page).to have_content alice.full_name
  end

end
