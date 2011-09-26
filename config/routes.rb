Importable::Engine.routes.draw do
  %w[ spreadsheet resource ].each do |import_type|
    match "/:type/#{import_type}",
          to: "#{import_type.pluralize}#new",
          as: "new_#{import_type}",
          via: "get"

    match "/:type/#{import_type}",
          to: "#{import_type.pluralize}#create",
          as: "#{import_type.pluralize}",
          via: "post"

    match "/:type/:id/#{import_type}",
          to: "#{import_type.pluralize}#show",
          as: "#{import_type}",
          via: "get"
  end
end
