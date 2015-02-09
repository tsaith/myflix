require 'spec_helper.rb'

feature "Admin sees payments" do

  background do
    alice = Fabricate(:user, full_name: "Tifa Lockhart", email: "tifa@example.com")
    Fabricate(:payment, amount: 999, user: alice)
  end

  scenario "admin can see payments" do
    sign_in(Fabricate(:admin))
    visit admin_payments_path

    expect(page).to have_content "Tifa Lockhart"
    expect(page).to have_content "$9.99"
    expect(page).to have_content "tifa@example.com"
  end

  scenario "user can not see payments" do
    sign_in(Fabricate(:user))
    visit admin_payments_path

    expect(page).not_to have_content "Tifa Lockhart"
    expect(page).not_to have_content "$9.99"
    expect(page).to have_content "You are not authorized to do that."
  end

end
