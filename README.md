# Importable #

An engine for importing spreadsheets (or `ActiveResources`) into a Rails app, easily.

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

You can also create mapper specific views. This is especially useful if you want the form to provide extra info to the mapper. The generator can create these views for you if you pass the name of the mapper.

    rails generate importable:view widgets

Write an import mapper

    TODO

Control redirection after upload

    TODO

Accept extra attributes from the import form

    TODO

Start using the UI to import data

    TODO

Testing import mappers

    TODO

Working with `ActiveResources`

    TODO

## TODO ##

Moves strings to en.yaml
DSL to make mappers cleaner
Make database optional
Add support for other file types that roo supports
Back button specs
Figure out how to allow overriding map specific templates in app/views/importable/spreadsheets/foos rather than app/views/foos/importable/spreadsheets
Initializer for configuration, should allow setting the file upload path
Underscored attribute aliases to incoming names with spaces
Allow views to be in a directories named 'import', possibly whatever the engine is mounted as
Importer#imported_items_ready? smells funny
