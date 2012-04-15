require 'thread'
require 'userMsgs'
class ServerClient 
  
  include UserMsgs
  
  def register(nickname,host,port )
    begin
      puts connecting host
      @socket = TCPSocket.new(host,port) 
      raise Exception.new("I can't bind the socket") if @socket.nil?
      @socket.write "register_info: #{nickname} #{@status} #{@uri}\n"     
    rescue => e
      puts connection_failed
      exit 0
    end
  end
  
  def read_from_console
    user_entry = STDIN.gets
    if user_entry == "quit\n"
      @online =  false
    end
    if !(user_entry.eql?"\n") && (user_entry =~ /to_s: /)
      @socket.write(user_entry)
    elsif (user_entry.chop.eql?"help")
      puts user_help
    elsif !(user_entry =~ /to_s: /)
      user_entry = user_entry.strip.split("=> ")
      @socket.write("to_s: translate #{user_entry[1]}\n")
      @current_msg, @current_rcv = user_entry[0], user_entry[1]
    else
      puts nothing_to_send
    end
  end

  def write_from_server
    @writter = Thread.new do 
      while @online
        begin
          if @socket.eof?
            @socket.close
            puts server_down
            @online = false
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
            puts "=> #{msg}"
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