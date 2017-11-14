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
CHAR_SET = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
CHAR_SET_SIZE = CHAR_SET.size
MESSAGES = [] of String
STATUSES = [] of String

ws "/chat" do |socket|
  # Add the client to SOCKETS list
  SOCKETS << socket

  # Broadcast each message to all clients
  socket.on_message do |message|
    SOCKETS.each { |socket|
      msg = { when: Time.now.to_utc, statuses: STATUSES, bot_message: "", human_message: message, socket: socket.to_s }.to_json
      MESSAGES << msg
      socket.send msg
    }
  end

  # Remove clients from the list when it's closed
  socket.on_close do
    SOCKETS.delete socket
  end
end

spawn do
  STATUSES << "running"
  while STATUSES.last == "running" && ! MESSAGES.last(10).includes?("bot_sleep_mode")
    begin
      msg = { when: Time.now.to_utc, statuses: STATUSES, bot_message: (1 + rand(6)).times.to_a.map {|i| CHAR_SET[rand(CHAR_SET_SIZE)] }.join, human_message: "", socket: "spawn" }.to_json
      puts "bot msg: #{msg}"
      # SOCKETS.each { |thesocket| thesocket.send("#{Time.now.to_utc}: #{msg}") }
      SOCKETS.each { |thesocket| thesocket.send(msg) }
      sleep(10)
    rescue
      puts "Socket send error!" # "#{ {dir: __DIR__, file: __FILE__, line: __LINE__, class: self.class.name, method: {{@def.name.stringify}}, message: "some message" }.pretty_inspect }"
    end
  end
  STATUSES << "sleeping"
  SOCKETS.each { |thesocket| thesocket.send({ when: Time.now.to_utc, statuses: STATUSES, message: (1 + rand(6)).times.to_a.map {|i| CHAR_SET[rand(CHAR_SET_SIZE)] }.join }.to_json) }
end

Kemal.run
