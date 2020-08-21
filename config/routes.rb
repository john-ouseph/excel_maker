Rails.application.routes.draw do
  root 'welcome#index'
  get 'populations/upload'
  get 'populations/import_file'
  post 'populations/import_file'
  get 'populations/delete_all'
  get 'populations/export'
  resources :populations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
