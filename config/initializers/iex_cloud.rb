require 'dotenv/load' 
require 'iex-ruby-client'  

IEX::Api.configure do |config|
    config.publishable_token = 'pk_23f3553501844564883691685d9a54c4' # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
    config.secret_token = 'sk_d67df174e2e247d59c359c10448bd0c8' # defaults to ENV['IEX_API_SECRET_TOKEN']
    config.endpoint = 'https://cloud.iexapis.com/v1' # use 'https://sandbox.iexapis.com/v1' for Sandbox
  end