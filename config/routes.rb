require Rails.root.join('lib', 'endpoints')

Storage::Application.routes.draw do
  match 'api/el_finder/v2' => 'el_finder/commands#create'
  match 'api/el_finder/v2/*root_path' => 'el_finder/commands#create'

  namespace :api do
    get '/files_by_node/:directory_id' => 'api#files_by_node'
    get '/find_entry_by_name' => 'api#find_entry_by_name'
  end

  # get image's region without watermark
  get '/files/:id/region/:width/:height/:x/:y/(:resized_width-:resized_height)(:cropify)(:gravity)/*name' => Endpoints.region,
    :defaults => { :watermark => true },
    :constraints => { :width => /\d+/,
                      :height => /\d+/,
                      :x => /\d+/,
                      :y => /\d+/,
                      :resized_width => /\d+/,
                      :resized_height => /\d+/,
                      :cropify => /(\!|c)/,
                      :gravity => /(e|ne|n|nw|se|s|sw|w)/ },
    :format => false

  # get image's region with watermark
  get '/w/files/:id/region/:width/:height/:x/:y/(:resized_width-:resized_height)(:cropify)(:gravity)/*name' => Endpoints.region { |thumbnail| Settings['watermark'] ? thumbnail.process(:watermark) : thumbnail },
    :defaults => { :watermark => true },
    :constraints => { :width => /\d+/,
                      :height => /\d+/,
                      :x => /\d+/,
                      :y => /\d+/,
                      :resized_width => /\d+/,
                      :resized_height => /\d+/,
                      :cropify => /(\!|c)/,
                      :gravity => /(e|ne|n|nw|se|s|sw|w)/ },
    :format => false

  # get images without watermark by default
  get '/files/:id/(:width-:height(:cropify)(:magnify)(:gravity))/*name' => Endpoints.default,
    :constraints => { :width => /\d+/,
                      :height => /\d+/,
                      :cropify => /(\!|c)/,
                      :magnify => /m/,
                      :gravity => /(e|ne|n|nw|se|s|sw|w)/ },
    :as => :files,
    :format => false

  # get images with watermark
  get '/w/files/:id/(:width-:height(:cropify)(:magnify)(:gravity))/*name' => Endpoints.default { |thumbnail| Settings['watermark'] ? thumbnail.process(:watermark) : thumbnail },
    :constraints => { :width => /\d+/,
                      :height => /\d+/,
                      :cropify => /(\!|c)/,
                      :magnify => /m/,
                      :gravity => /(e|ne|n|nw|se|s|sw|w)/ },
    :format => false

  delete '/external_links' => 'external_links#destroy'

  post '/external_links' => 'external_links#create'

  root :to => 'el_finder/roots#show'
end
