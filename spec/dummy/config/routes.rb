Rails.application.routes.draw do
  resources :foos, only: [:index]
  mount Importable::Engine => "/importable"
end
