require 'spec_helper.rb'

feature "User interacts with the queue" do

  scenario "user adds and reorders the video in the queue" do
    category = Fabricate(:category)
    final_fantasy = Fabricate(:video, category: category)
    dragon_quest = Fabricate(:video, category: category)
    secret_garden = Fabricate(:video, category: category)

    sign_in

    add_video_to_queue(final_fantasy)
    expect_video_to_be_in_queue(final_fantasy)

    visit video_path(final_fantasy)
    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(dragon_quest)
    add_video_to_queue(secret_garden)

    set_video_position(final_fantasy, 2)
    set_video_position(dragon_quest, 3)
    set_video_position(secret_garden, 1)
    update_queue

    expect_video_position(final_fantasy, 2)
    expect_video_position(dragon_quest, 3)
    expect_video_position(secret_garden, 1)

  end

  def add_video_to_queue(video)
    find("a[href='/videos/#{video.slug}']").click
    click_on "+ My Queue"
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content(video.title)
  end

  def expect_link_not_to_be_seen(link_text)
    expect(page).not_to have_content(link_text)
  end

  def add_video_to_queue(video)
    visit home_path
    find("a[href='/videos/#{video.slug}']").click
    find("#add_my_queue").click
  end

  def set_video_position(video, position)
    find("input[data-video-id='#{video.id}']").set(position)
  end

  def update_queue
    click_on "Update Instant Queue"
  end

  def expect_video_position(video, position)
    expect(find("input[data-video-id='#{video.id}']").value).to eq position.to_s
  end

end
