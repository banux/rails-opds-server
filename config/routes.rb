OpdsServer::Application.routes.draw do
  resources :categories

  get "search/index"

  devise_for :users

  get "home/index"

  get 'catalogs/index'
  match 'catalogs.atom' => 'catalogs#index', :format => :atom
  match 'catalogs/:user_id/all' => "catalogs#all", :as => "catalogs_all"
  match 'catalogs/:user_id/author' => "catalogs#author", :as => "catalogs_author"
  match 'catalogs/:user_id/tags' => "catalogs#tags", :as => "catalogs_tags"
  match 'catalogs/:user_id/serie' => "catalogs#serie", :as => "catalogs_serie"
  match 'catalogs/:user_id/featured' => "catalogs#featured", :as => "catalogs_featured"
  match 'catalogs/:user_id/category' => "catalogs#category", :as => "catalogs_category"
  get 'catalogs/bad_metadata'
  get 'catalogs/reading_list'
  get 'catalogs/share'
  post 'catalogs/share'
  get 'catalogs/author'
  get 'search.xml' => "search#opensearch", defaults: { format: "xml" }

  resources :books do
    member do
      get 'read_book'
      get 'unread_book'
    end
  end

  root :to => "home#index"

end
