DEFAULT_ENDPOINT = Dragonfly[:files].endpoint { |params, app|
  if params[:width]
    image = FileEntry.where(:file_mime_directory => 'image').where(:name => params[:name]).find(params[:id])
    gravity = nil
    if params[:magnify]
      width = [params[:width].to_i, image.file_width*3, 2000].min
      height = [params[:height].to_i, image.file_height*3, 2000].min
    else
      width = [params[:width].to_i, image.file_width].min
      height = [params[:height].to_i, image.file_height].min
    end
    gravity = params[:gravity] if params[:cropify]
    modificator = '#' if params[:cropify]
    image.file.thumb("#{width}x#{height}#{modificator}#{gravity}").strip
  else
    base_entry_name, *relative_path = params[:name].split('/')
    base_entry = FileEntry.where(:name => base_entry_name).find(params[:id])
    app.fetch base_entry.subfile(relative_path).file_uid
  end
}

Storage::Application.routes.draw do
  match 'api/el_finder/v2' => 'el_finder/commands#create'
  match 'api/el_finder/v2/*root_path' => 'el_finder/commands#create'

  get '/files/:id/region/:width/:height/:x/:y/(:resized_width-:resized_height)/*name' => Dragonfly[:files].endpoint { |params, app|
    image = FileEntry.where(:file_mime_directory => 'image').where(:name => params[:name]).find(params[:id])
    width, height = params[:width], params[:height]
    x, y = params[:x], params[:y]
    resized_width, resized_height = params[:resized_width], params[:resized_height]
    thumbnail = image.file.thumb("#{width}x#{height}+#{x}+#{y}").strip
    thumbnail = thumbnail.thumb("#{resized_width}x#{resized_height}") if resized_width && resized_height
    thumbnail
  }, :format => false

  get '/files/:id/(:width-:height(:cropify)(:magnify)(:gravity))/*name' => DEFAULT_ENDPOINT,
    :constraints => {
      :width => /\d+/,
      :height => /\d+/,
      :cropify => /(\!|c)/,
      :magnify => /m/,
      :gravity => /(e|ne|n|nw|se|s|sw|w)/,
    },
    :as => :files,
    :format => false

  delete '/external_links' => 'external_links#destroy'
  post '/external_links' => 'external_links#create'

  root :to => 'el_finder/roots#show'
end
