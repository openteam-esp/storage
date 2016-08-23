@depth = params[:depth].to_i

json.root do
  json.name @entry.name
  json.id @entry.id

  json.files @entry.files do |file|
    json.partial! 'file', file: file
  end

  json.partial! 'children', children: @entry.directories, depth: (@depth - 1) if @depth && @depth > 0
end
