Pool::Application.routes.draw do
  match 'api/el_finder/v2' => 'el_finder/commands#create'
  root :to => 'el_finder/roots#show'
end
