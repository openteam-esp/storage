Fabricator(:directory_entry) do
  name 'directory'
  parent { RootEntry.instance }
end
