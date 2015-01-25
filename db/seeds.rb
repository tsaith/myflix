# coding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Users
thtsai = User.create(email: "tsai.tsunghua@gmail.com", password: "password", full_name: "Tsung-Hua Tsai", admin: true)
alice = User.create(email: "alice@example.com", password: "password", full_name: "Alice Liddel")
tifa = User.create(email: "tifa@example.com", password: "password", full_name: "Tifa Lockhart")

# Categories
games = Category.create(name: "Games")
movies = Category.create(name: "Movies")

# Videos
def create_video(title, description, category, cover_url, video_url=nil)
  video = Video.new(title: title, description: description, category: category, video_url: video_url)
  video.remote_small_cover_url = cover_url
  video.remote_large_cover_url = cover_url
  video.save
  video
end

ff11 = create_video("FF XI", "Final Fantasy XI", games, "https://farm9.staticflickr.com/8612/16333983496_b897a07bb0_b.jpg", 'https://www.youtube.com/watch?v=UlWeE0cRr4U')
ff12 = create_video("FF XII", "Final Fantasy XII", games, "https://farm8.staticflickr.com/7459/16172320348_b896a65703_b.jpg", 'https://www.youtube.com/watch?v=xq7iLLFlerg')
ff13 = create_video("FF XIII", "Final Fantasy XIII", games, "https://farm9.staticflickr.com/8679/16173727369_951485217d_b.jpg", 'https://www.youtube.com/watch?v=yxMcuzOgVrU')

three_idiots = create_video("3 idiots", "Two friends are searching for their long lost companion. They revisit their college days and recall the memories of their friend who inspired them to think differently, even as the rest of the world called them 'idiots'.", movies, "https://farm8.staticflickr.com/7383/16172326428_937f4a734d_b.jpg", 'https://www.youtube.com/watch?v=K0eDlFX9GMc')
lucy = create_video("Lucy", "A woman, accidentally caught in a dark deal, turns the tables on her captors and transforms into a merciless warrior evolved beyond human logic.", movies, "https://farm8.staticflickr.com/7435/16333974806_45cd3fae74_o.jpg", 'https://www.youtube.com/watch?v=MVt32qoyhi0')
iron_man_3 = create_video("Iron Man 3", "When Tony Stark's world is torn apart by a formidable terrorist called the Mandarin, he starts an odyssey of rebuilding and retribution.", movies, "https://farm8.staticflickr.com/7329/16333974866_71e2266c59_b.jpg", 'https://www.youtube.com/watch?v=Ke1Y3P9D0Bc')

# Reviews
Review.create(user: thtsai, video: ff13, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: thtsai, video: ff12, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: thtsai, video: ff11, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: thtsai, video: three_idiots, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)

Review.create(user: alice, video: ff13, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: alice, video: lucy, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: tifa, video: iron_man_3, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)

# Queues
QueueItem.create(user: thtsai, video: ff13, position: 1)
QueueItem.create(user: thtsai, video: lucy, position: 2)
QueueItem.create(user: thtsai, video: three_idiots, position: 3)

QueueItem.create(user: alice, video: ff13, position: 1)
QueueItem.create(user: alice, video: lucy, position: 2)
QueueItem.create(user: alice, video: three_idiots, position: 3)

QueueItem.create(user: tifa, video: ff13, position: 1)
QueueItem.create(user: tifa, video: lucy, position: 2)
QueueItem.create(user: tifa, video: three_idiots, position: 3)

# Following relationships
Relationship.create(leader: thtsai, follower: alice)
Relationship.create(leader: thtsai, follower: tifa)
Relationship.create(leader: alice, follower: thtsai)
Relationship.create(leader: tifa, follower: thtsai)
