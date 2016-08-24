json.array! @entries do |entry|
  json.label entry.name
  json.id entry.id
end
