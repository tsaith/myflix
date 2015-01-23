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
def create_video(title, description, category, cover, url=nil)
  video = Video.new(title: title, description: description, category: category, video_url: url)
  video.small_cover = File.open(File.join(Rails.root, "public/samples/#{cover}"))
  video.large_cover = File.open(File.join(Rails.root, "public/samples/#{cover}"))
  video.save
  video
end

create_video("FF I", "Final Fantasy I", games, 'ff1.jpg', 'https://www.youtube.com/watch?v=E7cDlNuOVkM')
create_video("FF II", "Final Fantasy II", games, 'ff2.jpg', 'https://www.youtube.com/watch?v=xtt9PUZWKiY')
create_video("FF III", "Final Fantasy III", games, 'ff3.jpg', 'https://www.youtube.com/watch?v=cySEm8V2R3Y')
create_video("FF IV", "Final Fantasy IV", games, 'ff4.jpg', 'https://www.youtube.com/watch?v=IT12DW2Fm9M')
create_video("FF V", "Final Fantasy V", games, 'ff5.jpg', 'https://www.youtube.com/watch?v=0RG9GAaO77M')
create_video("FF VI", "Final Fantasy VI", games, 'ff6.jpg', 'https://www.youtube.com/watch?v=8Apk08fgDNg')
create_video("FF VII", "Final Fantasy VII", games, 'ff7.jpg', 'https://www.youtube.com/watch?v=fNJ1y9YUiLY')
create_video("FF VIII", "Final Fantasy VIII", games, 'ff8.jpg', 'https://www.youtube.com/watch?v=q09quI356sQ')
create_video("FF IX", "Final Fantasy IX", games, 'ff9.jpg', 'https://www.youtube.com/watch?v=ynZGdjuZMCU')
create_video("FF X", "Final Fantasy X", games, 'ff10.jpg', 'https://www.youtube.com/watch?v=sCJjHS3I0dY')
ff11 = create_video("FF XI", "Final Fantasy XI", games, 'ff11.jpg', 'https://www.youtube.com/watch?v=UlWeE0cRr4U')
ff12 = create_video("FF XII", "Final Fantasy XII", games, 'ff12.jpg', 'https://www.youtube.com/watch?v=xq7iLLFlerg')
ff13 = create_video("FF XIII", "Final Fantasy XIII", games, 'ff13.jpg', 'https://www.youtube.com/watch?v=yxMcuzOgVrU')
create_video("FF XIV", "Final Fantasy XIV", games, 'ff14.jpg', 'https://www.youtube.com/watch?v=39j5v8jlndM')

create_video("3 idiots", "Two friends are searching for their long lost companion. They revisit their college days and recall the memories of their friend who inspired them to think differently, even as the rest of the world called them 'idiots'.", movies, '3_idiots.jpg', 'https://www.youtube.com/watch?v=K0eDlFX9GMc')

create_video("Peaceful Warrior", "Dan Millman has it all: good grades, a shot at the Olympic team on the rings and girls lining up for the handsome Berkely college athlete all teams mates look up to with envy. Only one man shakes his confidence, an anonymous night gas station attendant, who like Socrates, keeps questioning every assumption in his life. Then a traffic crash shatters Dan's legs, and his bright future. Now Socrates's life coaching is to make or break Dan's revised ambition.Written by KGF Vissers'", movies, 'peaceful_warrior.jpg', 'https://www.youtube.com/watch?v=gegNMYvY_yg')

create_video("Avengers: Age of Ultron", "When Tony Stark tries to jumpstart a dormant peacekeeping program, things go awry and it is up to the Avengers to stop the villainous Ultron from enacting his terrible plans.", movies, 'avengers_2.jpg', 'https://www.youtube.com/watch?v=MZoO8QVMxkk')

lucy = create_video("Lucy", "A woman, accidentally caught in a dark deal, turns the tables on her captors and transforms into a merciless warrior evolved beyond human logic.", movies, 'lucy.jpg', 'https://www.youtube.com/watch?v=MVt32qoyhi0')

iron_man_3 = create_video("Iron Man 3", "When Tony Stark's world is torn apart by a formidable terrorist called the Mandarin, he starts an odyssey of rebuilding and retribution.", movies, 'iron_man_3.jpg', 'https://www.youtube.com/watch?v=Ke1Y3P9D0Bc')
create_video("The Amazing Spider-Man", "After Peter Parker is bitten by a genetically altered spider, he gains newfound, spider-like powers and ventures out to solve the mystery of his parent's mysterious death.", movies, 'amazing_spider_man.jpg', 'https://www.youtube.com/watch?v=16AwVWvjQhY')

# Reviews
Review.create(user: thtsai, video: ff13, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: thtsai, video: ff12, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: thtsai, video: ff11, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)

Review.create(user: alice, video: ff13, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: alice, video: lucy, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)
Review.create(user: tifa, video: iron_man_3, rating:  (1..5).to_a.sample, content: Faker::Lorem::paragraph)

# Queues
QueueItem.create(user: thtsai, video: ff13, position: 1)
QueueItem.create(user: thtsai, video: lucy, position: 2)
QueueItem.create(user: thtsai, video: iron_man_3, position: 3)

QueueItem.create(user: alice, video: ff13, position: 1)
QueueItem.create(user: alice, video: lucy, position: 2)
QueueItem.create(user: alice, video: iron_man_3, position: 3)

QueueItem.create(user: tifa, video: ff13, position: 1)
QueueItem.create(user: tifa, video: lucy, position: 2)
QueueItem.create(user: tifa, video: iron_man_3, position: 3)

# Following relationships
Relationship.create(leader: thtsai, follower: alice)
Relationship.create(leader: thtsai, follower: tifa)
Relationship.create(leader: alice, follower: thtsai)
Relationship.create(leader: tifa, follower: thtsai)
