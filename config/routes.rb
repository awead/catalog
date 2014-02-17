Catalog::Application.routes.draw do
  Blacklight::Marc.add_routes(self)
  blacklight_for :catalog

  root :to => "catalog#index"

  devise_for :users

  # For EAD
  match "components/:id(/:ref)", :to => "components#index", :via => :get
  match "catalog/:id/:ref", :to => "catalog#show", :via => :get

  # Holdings
  match "holdings/:id" => "holdings#show", :as => :holdings, :via => :get

  match "*a", :to => "catalog#index", :via => [:get, :post] if Rails.env.match?("production")
end
