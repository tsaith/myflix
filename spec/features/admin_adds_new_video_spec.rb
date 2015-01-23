require 'spec_helper.rb'

feature "Admin adds new video" do

  scenario "Admin successfully adds a new video" do

    Fabricate(:category, name: "Movies")
    admin = Fabricate(:admin)

    sign_in(admin)
    visit new_admin_video_path

    fill_in "Title", with: "Lucy"
    select "Movies", from: "Category"
    fill_in "Description", with: "A nice movie!"
    attach_file "Large cover", "spec/support/uploads/lucy_large.jpg"
    attach_file "Small cover", "spec/support/uploads/lucy.jpg"
    fill_in "Video URL", with: "http://www.example.com/my_video.mp4"

    click_button "Add Video"
    sign_out

    # Regular user
    sign_in
    visit video_path(Video.first)

    expect(page).to have_content "Lucy"
    expect(page).to have_selector "img[src='/uploads/video/large_cover/1/lucy_large.jpg']"
    expect(page).to have_selector "a[href='http://www.example.com/my_video.mp4']"

  end

end
