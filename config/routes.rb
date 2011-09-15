Importable::Engine.routes.draw do
  match "/:type",
        to: 'spreadsheets#new',
        as: 'new_spreadsheet',
        via: 'get'

  match "/:type",
        to: 'spreadsheets#create',
        as: 'spreadsheets',
        via: 'post'

  match "/:type/:id",
        to: 'spreadsheets#show',
        as: 'spreadsheet',
        via: 'get'
end
