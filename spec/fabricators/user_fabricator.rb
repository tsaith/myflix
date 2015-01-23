Fabricator(:user) do
  email { Faker:: Internet.email }
  password { Faker::Internet.password }
  full_name { Faker::Name.name }
end

Fabricator(:admin, from: :user) do
  admin { true }
end
