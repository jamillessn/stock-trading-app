##### Prerequisites

The setups steps expect following tools installed on the system.

- Github
- Ruby [3.3.0](https://github.com/ruby/ruby/releases/tag/v3_3_2)
- Rails [7.1.3](https://github.com/rails/rails/releases/tag/v7.1.3)

##### 1. Check out the repository

```bash
git clone git@github.com:jamillessn/stock-trading-app.git
```

##### 2. Create database.yml file

Copy the sample database.yml file and edit the database configuration as required.

```bash
cp config/database.yml.sample config/database.yml
```

##### 3. Create and setup the database

Run the following commands to create and setup the database.

```ruby
bundle exec rails db:create
bundle exec rails db:setup
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```ruby
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000

# GEMS used:
* Devise
* TailwindCSS
* IEX Ruby Client
* Httparty
* Letter Opener
* Letter Opener Web
* Inline SVG
* Redis rails #for cache
