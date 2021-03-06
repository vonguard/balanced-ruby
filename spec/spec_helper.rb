require 'rubygems'
require 'bundler/setup'
require 'balanced'
require 'vcr'
require 'json'

begin
  require 'ruby-debug'
rescue LoadError
# ignored
end


VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :faraday
  c.configure_rspec_metadata!
end

# TODO: better way to do this?
host = ENV['BALANCED_HOST'] or nil
options = {}
if !host.nil? then
  options[:scheme] = 'http'
  options[:host] = host
  options[:port] = 5000
  options[:ssl_verify] = false
  Balanced.configure(nil, options)
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true

  # @return [Balanced::Marketplace]
  def make_marketplace
    api_key = Balanced::ApiKey.new.save
    Balanced.configure api_key.secret
    Balanced::Marketplace.new.save
  end

  # @example Use this metadata to create a marketplace in a before block
  #   describe "something under test", vcr: true, marketplace: true do
  #     it "works" do
  #       # ...
  #     end
  #   end
  c.before(:each, marketplace: true) do
    make_marketplace
  end
end


ACCOUNTS_URI_REGEX = /\/v1\/marketplaces\/TEST-\w*\/accounts/
MERCHANT_URI_REGEX = /\/v1\/marketplaces\/TEST-\w*\/accounts\/\w*/
HOLDS_URI_REGEX = /\/v1\/marketplaces\/TEST-\w*\/accounts\/\w*\/holds/
BANK_ACCOUNTS_URI_REGEX = /\/v1\/marketplaces\/TEST-\w*\/accounts\/\w*\/bank_accounts/
REFUNDS_URI_REGEX = /\/v1\/marketplaces\/TEST-\w*\/accounts\/\w*\/refunds/
DEBITS_URI_REGEX = /\/v1\/marketplaces\/TEST-\w*\/accounts\/\w*\/debits/
TRANSACTIONS_URI_REGEX = /\/v1\/marketplaces\/TEST-\w*\/accounts\/\w*\/transactions/
CREDITS_URI_REGEX = /\/v1\/marketplaces\/TEST-\w*\/accounts\/\w*\/credits/
CARDS_URI_REGEX = /\/v1\/marketplaces\/TEST-\w*\/accounts\/\w*\/cards/
CUSTOMERS_URI_REGEX = /\/v1\/customers/
