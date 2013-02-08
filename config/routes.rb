OpdsServer::Application.routes.draw do
  resources :categories

  get "search/index"

  devise_for :users

  get "home/index"

  get 'catalogs/index'
  match 'catalogs.atom' => 'catalogs#index', :format => :atom
  get 'catalogs/all'
  get 'catalogs/author'
  get 'catalogs/tags'
  get 'catalogs/serie'
  get 'catalogs/featured'
  get 'catalogs/category'
  get 'catalogs/bad_metadata'
  get 'catalogs/reading_list'

  resources :books do
    member do
      get 'read_book'
      get 'unread_book'
    end
  end

  root :to => "home#index"

end
