require 'spec_helper.rb'

feature "Admin adds new video" do

  scenario "Admin successfully adds a new video" do

    Fabricate(:category, name: "Movies")
    admin = Fabricate(:admin)

    sign_in(admin)
    visit new_admin_video_path
    add_new_video
    sign_out

    # Regular user
    sign_in
    video = Video.first
    visit video_path(video)

    expect_to_see_large_cover(video)
    expect_to_see_video_url(video)
  end

  def add_new_video
    fill_in "Title", with: "Lucy"
    select "Movies", from: "Category"
    fill_in "Description", with: "A nice movie!"
    attach_file "Large cover", "spec/support/uploads/lucy_large.jpg"
    attach_file "Small cover", "spec/support/uploads/lucy.jpg"
    fill_in "Video URL", with: "http://www.example.com/my_video.mp4"
    click_button "Add Video"
  end

  def expect_to_see_large_cover(video)
    expect(page).to have_selector "img[src='#{video.large_cover_url}']"
  end

  def expect_to_see_video_url(video)
    expect(page).to have_selector "a[href='#{video.video_url}']"
  end
end
