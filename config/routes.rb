Catalog::Application.routes.draw do
  Blacklight.add_routes(self)

  root :to => "front_page#index"

  devise_for :users

  # For EAD
  resources :components, :only => [:index]
  match 'catalog/:id/ead_xml', :to => "catalog#ead_xml", :as => "ead_xml", :via => :get
  match 'catalog/:id/:ref', :to => "catalog#show", :via => :get

  # Holdings
  match "holdings/:id" => "holdings#show", :via => :get, :as => :holdings, :via => :get

  # fuck you, recscue_from, and your stupid bullshit
  match '*a', :to => 'catalog#index', :via => [:get, :post]

end
