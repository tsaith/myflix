require 'spec_helper.rb'

feature "User registers", { js: true, vcr: true } do

  background do
    page.driver.allow_url("js.stripe.com")
    page.driver.allow_url("api.stripe.com")
    page.driver.allow_url("www.gravatar.com")
    visit sign_up_path
  end
  after { clear_email }

  scenario "with valid user info and valid card" do
    fill_in_valid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect_to_see_welcome_message
  end
  scenario "with valid user info and invalid card" do
    fill_in_valid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect_to_see_invalid_card_message
  end
  scenario "with valid user info and declined card" do
    fill_in_valid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect_to_see_declined_card_message
  end
  scenario "with invalid user info and valid card" do
    fill_in_invalid_user_info
    fill_in_valid_card
    click_button "Sign Up"
    expect_to_see_invalid_user_message
end
  scenario "with invalid user info and invalid card" do
    fill_in_invalid_user_info
    fill_in_invalid_card
    click_button "Sign Up"
    expect_to_see_invalid_card_message
  end
  scenario "with invalid user info and declined card" do
    fill_in_invalid_user_info
    fill_in_declined_card
    click_button "Sign Up"
    expect_to_see_declined_card_message
  end

  def fill_in_valid_user_info
    fill_in "Email Address", with: "cloud@example.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Cloud Strife"
  end

  def fill_in_invalid_user_info
    fill_in "Email Address", with: "cloud@example.com"
    fill_in "Password", with: ""
    fill_in "Full Name", with: "Cloud Strife"
  end

  def fill_in_valid_card
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "4 - April", from: "date_month"
    select "2018", from: "date_year"
  end

  def fill_in_invalid_card
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: ""
    select "4 - April", from: "date_month"
    select "2018", from: "date_year"
  end

  def fill_in_declined_card
    fill_in "Credit Card Number", with: "4000000000000002"
    fill_in "Security Code", with: "123"
    select "4 - April", from: "date_month"
    select "2018", from: "date_year"
  end

  def expect_to_see_welcome_message
    expect(page).to have_content "Welcome, Cloud Strife"
  end

  def expect_to_see_invalid_user_message
    expect(page).to have_content "Invalid user information. Please check the errors below."
  end

  def expect_to_see_invalid_card_message
    expect(page).to have_content "Your card's security code is invalid."
  end

  def expect_to_see_declined_card_message
    expect(page).to have_content "Credit Card Number Security Code Expiration"
  end

end
