Fabricator(:file_entry) do
  file    { File.new("#{Rails.root}/spec/fixtures/file.txt") }
  parent  { RootEntry.instance }
end
