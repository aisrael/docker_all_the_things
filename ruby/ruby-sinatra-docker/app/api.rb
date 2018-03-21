# frozen_string_literal: true

require 'sinatra'
require 'sinatra/json'

set :bind, '0.0.0.0'

get '/hello' do
  who = params['who'] || 'world'
  json(
    data: {
      greeting: "Hello, #{who}!"
    }
  )
end
