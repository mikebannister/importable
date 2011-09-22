# Importable #

Import spreadsheets and map data to rails models, easily.

## Synopsis ##

Provides models and a UI for creating and maintaining string pairs. A tiny DSL is included so developers to easily make use of the generated data. The UI allows system administrators to create groups of string pairs that can be maintained by non-technical people.

Add it to your `Gemfile`

    gem 'importable'

Bundle it up

    bundle install

Install the migrations and apply them

    rake importable:install:migrations
    rake db:migrate

Mount the engine

    mount Importable::Engine => '/import'

You can use the included generator to copy the views if you'd like to customize them

    rails generate importable:views

Write an import mapper

  TODO

Use the provided UI to import data

  TODO

## TODO ##

Moves strings to en.yaml
DSL to make mappers cleaner
Make database optional
Add support for other file types that roo supports
