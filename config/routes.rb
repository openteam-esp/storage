Pool::Application.routes.draw do
  match 'api/el_finder/v2' => 'el_finder/commands#create'

  get '/files/:id/*name' => Dragonfly[:pool].endpoint { |params, app|
    app.fetch(FileEntry.where(:id => params[:id]).find_by_name(params[:name]).file_uid)
  }, :as => :files, :format => false

  root :to => 'el_finder/roots#show'
end
