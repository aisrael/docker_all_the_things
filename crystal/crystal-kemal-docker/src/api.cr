require "./api/*"

# TODO: Write documentation for `Api`
module Api
  # TODO: Put your code here
end

require "kemal"

get "/hello" do |env|
  who = env.params.query["who"] || "world"
  "Hello, #{who}!"
end

Kemal.run
