# Installation

## Replace sensitive information (marked as ?) in files:
* /config/database.yml
* /config/environments/production.rb
* /lib/tasks/xml.rake

## Install:
    $ bundle install

## Creates database:
    $ bundle exec rake db:migrate

## Select sources:
    $ vim /lib/tasks/xml.rake

## Populate database:
    $ bundle exec rake xml:import
