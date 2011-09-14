Rails.application.routes.draw do

  mount Importable::Engine => "/importable"
end
