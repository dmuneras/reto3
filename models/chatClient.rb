require 'drb/drb'
require 'serverClient'
require 'chat'
class ChatClient < ServerClient

  attr_accessor :chat
  def initialize(nickname,host,port,status)
    @nickname, @status, @online, self.chat = nickname, status, true , Chat.new
    @uri = self.chat.address 
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