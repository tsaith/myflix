# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Todo.create(name:"cook dinner")
Todo.create(name:"eat")
Todo.create(name:"wash disher")

Video.create(title: "FFVII", description: "Final Fantasy VII", cover_image_url: "/img/ff7.jpg", demo_image_url: "/img/ff7.jpg", category_id: 1)
Video.create(title: "FFVIII", description: "Final Fantasy VIII", cover_image_url: "/img/ff8.jpg", demo_image_url: "/img/ff8.jpg", category_id: 1)
Video.create(title: "Lucy", description: "A woman, accidentally caught in a dark deal, turns the tables on her captors and transforms into a merciless warrior evolved beyond human logic.", cover_image_url: "/img/lucy.jpg", demo_image_url: "/img/lucy.jpg", category_id: 2)
Video.create(title: "3 idiots", description: "Two friends are searching for their long lost companion. They revisit their college days and recall the memories of their friend who inspired them to think differently, even as the rest of the world called them 'idiots'", cover_image_url: "/img/3 idiots.jpg", demo_image_url: "/img/3 idiots.jpg", category_id: 2)

Category.create(name: "Game")
Category.create(name: "Movie")
