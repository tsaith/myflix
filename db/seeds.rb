# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


thtsai = User.create(email: "tsai.tsunghua@gmail.com", password: "password", full_name: "Tsung-Hua Tsai", admin: true)
alice = User.create(email: "alice@example.com", password: "password", full_name: "Alice Liddel")
tifa = User.create(email: "tifa@example.com", password: "password", full_name: "Tifa Lockhart")

games = Category.create(name: "Games")
movies = Category.create(name: "Movies")

Video.create(title: "FFI", description: "Final Fantasy I", small_cover: "/img/ff1.jpg", large_cover: "/img/ff1.jpg", category: games)
Video.create(title: "FFII", description: "Final Fantasy II", small_cover: "/img/ff2.jpg", large_cover: "/img/ff2.jpg", category: games)
Video.create(title: "FFIII", description: "Final Fantasy III", small_cover: "/img/ff3.jpg", large_cover: "/img/ff3.jpg", category: games)
Video.create(title: "FFIV", description: "Final Fantasy IV", small_cover: "/img/ff4.jpg", large_cover: "/img/ff4.jpg", category: games)
Video.create(title: "FFV", description: "Final Fantasy V", small_cover: "/img/ff5.jpg", large_cover: "/img/ff5.jpg", category: games)
Video.create(title: "FFVI", description: "Final Fantasy VI", small_cover: "/img/ff6.jpg", large_cover: "/img/ff6.jpg", category: games)
Video.create(title: "FFVII", description: "Final Fantasy VII", small_cover: "/img/ff7.jpg", large_cover: "/img/ff7.jpg", category: games)
ff8 = Video.create(title: "FFVIII", description: "Final Fantasy VIII", small_cover: "/img/ff8.jpg", large_cover: "/img/ff8.jpg", category: games)

lucy = Video.create(title: "Lucy", description: "A woman, accidentally caught in a dark deal, turns the tables on her captors and transforms into a merciless warrior evolved beyond human logic.", small_cover: "/img/lucy.jpg", large_cover: "/img/lucy.jpg", category: movies)
Video.create(title: "3 idiots", description: "Two friends are searching for their long lost companion. They revisit their college days and recall the memories of their friend who inspired them to think differently, even as the rest of the world called them 'idiots'", small_cover: "/img/3 idiots.jpg", large_cover: "/img/3 idiots.jpg", category: movies)


Review.create(user: thtsai, video: ff8, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: thtsai, video: ff8, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: thtsai, video: ff8, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)

Review.create(user: alice, video: ff8, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: alice, video: lucy, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: tifa, video: ff8, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)

QueueItem.create(user: thtsai, video: ff8, position: 1)
QueueItem.create(user: thtsai, video: lucy, position: 2)

QueueItem.create(user: alice, video: ff8, position: 1)
QueueItem.create(user: alice, video: lucy, position: 2)

Relationship.create(leader: thtsai, follower: alice)
Relationship.create(leader: thtsai, follower: tifa)
Relationship.create(leader: alice, follower: thtsai)
Relationship.create(leader: tifa, follower: thtsai)
