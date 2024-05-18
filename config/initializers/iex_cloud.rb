require 'dotenv/load' 
require 'iex-ruby-client'  

IEX::Api.configure do |config|
    config.publishable_token = 'pk_b345482ab42840f8905c88bb7c3e6c89' 
    config.secret_token = 'sk_619859abf5064fdca965e6d5ad0b9aac' 
    config.endpoint = 'https://cloud.iexapis.com/v1' 
  end