json.root do
  json.name @entry.name
  json.id @entry.id

  json.children @children do |child|
    json.name child.name
    json.id child.id

    json.files child.files do |file|
      json.name file.name
      json.url file.url
    end
  end
end
