require 'thread'
class ServerClient 
  
  
  def register(nickname,host,port )
    puts "Trying to connect: " + host
    @socket = TCPSocket.new(host,port) 
    raise Exception.new("I can't bind the socket") if @socket.nil?
    str =  "register_info: #{nickname} #{@status} #{@uri}\n"
    @socket.write(str)
  end
  
  
  def read_from_console
    flag = true
    while flag
      user_entry = STDIN.gets
      if user_entry == "quit\n"
        @online =  false
        break
      end
      if !(user_entry.eql?"\n") && (user_entry =~ /to_server: /)
        @socket.write(user_entry)
        flag = false
      elsif (user_entry.chop.eql?"help")
        puts "To send message to de server. write: to_server: <command> , to send message to an user, <msg> => <username>"
        flag = false
      elsif !(user_entry =~ /to_server: /)
        user_entry = user_entry.strip.split("=> ")
        @socket.write("to_server: translate #{user_entry[1]}\n")
        @current_msg = user_entry[0]
        @current_rcv = user_entry[1]
        flag = false
      else
        puts "(-.-) Nothing to send"
      end
    end
  end

  def write_from_server
    @writter = Thread.new do 
      while @online
        begin
          if @socket.eof?
            @socket.close
            puts "Server is down, please write quit"
            break
          end
          msg =  @socket.gets.chop
          if(msg =~ /translate:/)
            msg = msg.strip.split
            send(msg[1])
          elsif msg =~ /already exist/
            puts msg
            @online = false
          else
            msg = "=> #{msg}"
            puts msg
          end
        rescue => e
          puts "Error writter Thread #{e}"
        end
      end
    end
  end
  
  def send(uri)
    extChat = DRbObject.new_with_uri(uri)
    extChat.new_entry(@nickname, @current_rcv,@current_msg)
    extChat.print_msgs(@nickname)
  end
end