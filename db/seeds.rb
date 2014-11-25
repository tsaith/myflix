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

Video.create(title: "FFVII", description: "Final Fantasy VII",
             cover_image_url: "/ff/ff7.jpg", url_large: "/ff/ff7_large.jpg")
Video.create(title: "FFVIII", description: "Final Fantasy VIII",
             cover_image_url: "/ff/ff8.jpg", url_large: "/ff/ff8_large.jpg")
