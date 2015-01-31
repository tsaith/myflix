require 'spec_helper.rb'

feature "User invite friend" do

  background do
    page.driver.allow_url("js.stripe.com")
    page.driver.allow_url("api.stripe.com")
    page.driver.allow_url("www.gravatar.com")
  end
  after { clear_email }

  scenario "user successfully invites a friend and invitation is accepted ", { js: true, vcr: true } do
    alice = Fabricate(:user)
    sign_in(alice)

    invite_a_friend_and_sign_out
    friend_accepts_invitation
    friend_signs_in
    expect_friend_to_follow_inviter(alice)
    expect_inviter_to_follow_friend(alice)
  end

  def invite_a_friend_and_sign_out
    visit new_invitation_path

    fill_in "Friend's Name", with: "Tifa Lockhart"
    fill_in "Friend's Email Address", with: "tifa@example.com"
    fill_in "Message", with: "Please join this really cool site!"
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    open_email("tifa@example.com")
    current_email.click_link "Accept this invitation"

    fill_in "Email Address", with: "tifa@example.com"
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Tifa Lockhart"
    fill_in "Credit Card Number", with: "4242424242424242"
    fill_in "Security Code", with: "123"
    select "4 - April", from: "date_month"
    select "2019", from: "date_year"
    click_button "Sign Up"
    wait_for_friend_has_been_added
  end

  def friend_signs_in
    visit sign_in_path

    fill_in "Email Address", with: "tifa@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"
  end

  def expect_friend_to_follow_inviter(user)
    click_link "People"
    expect(page).to have_content(user.full_name)
    sign_out
  end

  def expect_inviter_to_follow_friend(inviter)
    sign_in(inviter)
    click_link "People"
    expect(page).to have_content("Tifa Lockhart")
  end

  def wait_for_friend_has_been_added
    waiting_time = 3.5 # in seconds
    sleep waiting_time unless User.count == 2
  end
end
