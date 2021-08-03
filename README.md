# TrueArtists

## Prerequisites 
- Install `rvm` -> \curl -sSL https://get.rvm.io | bash
- Install `ruby` -> \curl -sSL https://get.rvm.io | bash -s stable --ruby
- Install `Mysql` or Postgres -> 
- Install Redis server 
- Install Elastic search -> https://www.elastic.co/guide/en/elasticsearch/reference/current/brew.html

## Setup 
1. Clone the repository 
2. Go into the directory of the repo 
3. Run `bundle install`
4. Run `cp config/database.yml.example config/database.yml`
5. Run `cp config/application.yml.exmple config/application.yml`
6. Run `cp config/storage.yml.example config/storage.yml`
7. Run `bundle exec rails db:create; bundle exec rails db:migrate`
8. Run server `
