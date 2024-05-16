require 'dotenv/load' 
require 'iex-ruby-client'  

IEX::Api.configure do |config|
    config.publishable_token = 'pk_25cc7b50024a4f2dbd70105c802bd694' 
    config.secret_token = 'sk_85666730572d4953ad81b471373cf4ce' 
    config.endpoint = 'https://cloud.iexapis.com/v1' 
  end