require 'drb/drb'
require 'serverClient'
require 'chat'
class ChatClient < ServerClient

  attr_accessor :chat
  def initialize(nickname,host,port,status, address)
    @nickname = nickname
    @status = status
    @online = true
    @uri = address
    register(nickname,host,port)
    self.chat = Chat.new(address)
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