Rails.application.routes.draw do
  resources :foos, only: [:index]
  mount Importable::Engine => "/import"
  
  match "/" => redirect("/import/foo/spreadsheet")
end
