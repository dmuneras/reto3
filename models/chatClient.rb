require 'drb/drb'
require 'serverClient'
require 'chat'
class ChatClient < ServerClient

  attr_accessor :chat
  def initialize(nickname,host,port,status)
    @nickname = nickname
    @status = status
    @online = true
    self.chat = Chat.new
    @uri = self.chat.address 
    puts "La direccion es #{@uri}"
    register(nickname,host,port)
    write_from_server  
    main_loop
  end
  
  def main_loop
    while @online
       read_from_console
    end
    self.chat.stop
  end
  
end