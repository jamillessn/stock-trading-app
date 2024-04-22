require 'dotenv/load' # Loads environment variables from .env
require 'iex-ruby-client'  # If you installed the gem

IEX_CLIENT = IEX::Api::Client.new(
    publishable_token: ENV['pk_64a94b68c5c843868a5f955516a6edb9'],
    secret_token: ENV['sk_5e8df1e4276a468c9272cf50979557d9'],
    endpoint: 'https://sandbox.iexapis.com/v1' # Use sandbox for testing
)
