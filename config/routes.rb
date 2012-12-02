Catalog::Application.routes.draw do
  Blacklight.add_routes(self)

  root :to => "catalog#index"

  devise_for :users

  # For EAD
  resources :components, :only => [:index]
  match "/components/hide", :as => "components_hide"

  # Holdings
  match "holdings/:id" => "holdings#show", :via => :get, :as => :holdings

  # fuck you, recscue_from, and your stupid bullshit
  match '*a', :to => 'catalog#index'

end
