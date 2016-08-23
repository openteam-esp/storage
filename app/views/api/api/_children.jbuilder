json.children children do |child|
  json.name child.name
  json.id child.id

  json.files child.files do |file|
    json.partial! 'file', file: file
  end

  json.partial! 'children', children: child.directories, depth: depth if depth > 0
end
