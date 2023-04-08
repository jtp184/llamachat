require 'json'
require 'securerandom'
require 'llamaste'
require 'thin'
require 'sinatra'
require 'sinatra/base'
require 'sinatra-websocket'

set :server, 'thin'

class ChatApp < Sinatra::Base
  MODEL_PARAMS = { model: '/.code/C/llama/llama-cpp/models/gpt4all/gpt4all-lora-quantized-new.bin', tokens: 512 }
  BREAK_ON = []

  set :sockets, []
  set :llama, Llamaste::Model.new(MODEL_PARAMS).tap(&:load_model)
  set :public_folder, 'public'

  get '/' do
    erb :index
  end

  get '/socket' do
    if request.websocket?
      request.websocket do |socket|
        socket.onopen { settings.sockets << socket }
        socket.onmessage { |m| process_message(socket, m) }
        socket.onclose { settings.sockets.delete(socket) }
      end
    end
  end

  private

  def process_message(socket, msg)
    uuid = SecureRandom.uuid

    Thread.new do
      socket.send(JSON.dump({ status: :start, uuid: }))
      puts "STARTED (#{uuid})"

      settings.llama.call(msg, break_on: BREAK_ON) do |token|
        socket.send(JSON.dump({ status: :continue, token:, uuid: }))
        print '.'
      end

      socket.send(JSON.dump({ status: :finish, uuid: }))
      puts "\nFINISHED (#{uuid})"
    end
  end
end
