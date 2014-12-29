require 'spec_helper.rb'

feature "User interacts with the queue" do

  scenario "user follows another user" do
    category = Fabricate(:category)
    video = Fabricate(:video, category: category)

    alice = Fabricate(:user)
    Fabricate(:review, user: alice, video: video)

    sign_in
    click_on_video_on_home_page(video)
    click_on_user(alice)

    follow(alice)
    expect_user_to_be_seen(alice)

    unfollow(alice)
    expect_user_not_to_be_seen(alice)
  end

  def follow(user)
    click_on "Follow"
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end

  def click_on_user(user)
    find("a[href='/users/#{user.slug}']").click
  end

  def expect_user_to_be_seen(user)
    expect(page).to have_content(user.full_name)
  end

  def expect_user_not_to_be_seen(user)
    expect(page).not_to have_content(user.full_name)
  end

end
