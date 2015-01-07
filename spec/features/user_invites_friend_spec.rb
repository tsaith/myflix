require 'spec_helper.rb'

feature "User invite friend" do

  after { clear_email }

  scenario "user successfully invites a friend and invitation is accepted " do
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
    click_button "Sign up"
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

end
