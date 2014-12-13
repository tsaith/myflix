Fabricator(:video) do
  title { Faker::Lorem.words.join(" ") }
  description { Faker::Lorem::paragraph(1) }
end
