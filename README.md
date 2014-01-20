# Installation

## Clone:
    $ git clone https://github.com/cristheinz/crd_app_recipe.git

## Replace sensitive information in files:
* /config/database.yml
* /config/environments/production.rb
* /lib/tasks/xml.rake

## Install:
    $ bundle install

## Creates database:
    $ bundle exec rake db:migrate RAILS_ENV="production"

## Select sources:
    $ vim /lib/tasks/xml.rake

## Populate database:
    $ bundle exec rake xml:import
