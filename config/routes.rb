Storage::Application.routes.draw do
  match 'api/el_finder/v2' => 'el_finder/commands#create'
  match 'api/el_finder/v2/*root_path' => 'el_finder/commands#create'

  get '/files/:id/:width-:height!/*name' => Dragonfly[:files].endpoint { |params, app|
    image = FileEntry.where(:file_mime_directory => 'image').find(params[:id])
    width = [params[:width].to_i, image.file_width].min
    height = [params[:height].to_i, image.file_height].min
    image.file.thumb("#{width}x#{height}#")
  }, :as => :cropped_images, :format => false

  get '/files/:id/:width-:height/*name' => Dragonfly[:files].endpoint { |params, app|
    image = FileEntry.where(:file_mime_directory => 'image').find(params[:id])
    width = [params[:width].to_i, image.file_width].min
    height = [params[:height].to_i, image.file_height].min
    image.file.thumb("#{width}x#{height}")
  }, :as => :resized_images, :format => false

  get '/files/:id/*name' => Dragonfly[:files].endpoint { |params, app|
    app.fetch(FileEntry.where(:id => params[:id]).find_by_name(params[:name]).file_uid)
  }, :as => :files, :format => false

  delete '/external_links' => 'external_links#destroy'
  post '/external_links' => 'external_links#create'

  root :to => 'el_finder/roots#show'
end
