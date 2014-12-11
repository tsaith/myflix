Fabricator(:queue_item) do
  position { (1..10).to_a.sample }
end
