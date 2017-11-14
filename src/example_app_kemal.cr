require "kemal"
require "./example_app_kemal/*"

module ExampleAppKemal
  # TODO Put your code here
end

get "/" do
  "Hello World!"
end

# chat
get "/chat" do
  # TODO: update past Crystal 0.23.1 to get fix for "Error executing run: ecr/process", as noted in "https://github.com/crystal-lang/crystal/issues/4577"
  render "views/chat/index.ecr"
end

SOCKETS = [] of HTTP::WebSocket

ws "/chat" do |socket|
  # Add the client to SOCKETS list
  SOCKETS << socket

  # Broadcast each message to all clients
  socket.on_message do |message|
    SOCKETS.each { |socket| socket.send message}
  end

  # Remove clients from the list when it's closed
  socket.on_close do
    SOCKETS.delete socket
  end
end

Kemal.run
