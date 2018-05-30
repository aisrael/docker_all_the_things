require "./api/*"

# TODO: Write documentation for `Api`
module Api
  # TODO: Put your code here
end

require "kemal"

get "/hello" do |env|
  env.response.content_type = "application/json"
  who = env.params.query["who"]? || "world"
  {
    data: {
      greeting: "Hello, #{who}!"
    }
  }.to_json
end

Kemal.run
