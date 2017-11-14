require "kemal"
require "./example_app_kemal/*"

module ExampleAppKemal
  # TODO Put your code here
end

get "/" do
  "Hello World!"
end

Kemal.run