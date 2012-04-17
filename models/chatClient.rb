require 'drb/drb'
require 'chat'
require 'thread'
require 'userMsgs'

class ChatClient

  include UserMsgs
  attr_accessor :chat
  
  def initialize(nickname,host,port,status)
    @nickname, @status, @online, self.chat = nickname, status, true , Chat.new
    @uri = self.chat.address 
    register(nickname,host,port)
    write_from_server
    @users = []  
    main_loop
  end

  def main_loop
    while @online
      read_from_console
    end
    self.chat.stop
  end

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
    user_entry = user_entry.chop
    if user_entry == "quit"
      @online =  false
    elsif user_entry.eql?"\n"
      puts nothing_to_send
    elsif user_entry.eql?"help"
      puts user_help
    elsif user_entry.eql?"resolved_users"
      puts users_list @users
    elsif user_entry =~ /to_s: /
      @socket.write("#{user_entry}\n")
    else
      resolve_username user_entry  
    end
  end

  def write_from_server
    @writter = Thread.new do 
      begin
        while @online
          if @socket.eof?
            @socket.close
            puts server_down
            break
          end
          msg =  @socket.gets.chop
          if(msg =~ /translate:/)
            msg = msg.strip.split
            if(msg[1].eql?"wrong")
              puts "User is not available or the username is invalid, use command 'to_s: users'"
            else
              send(msg[1], msg[2],true)
            end
          elsif msg =~ /status:/
            msg = msg.strip.split
            update_status(msg[1] , msg[2])
          elsif msg =~ /already exist/
            puts msg
            @online = false
          else
            puts "=> #{msg}"
          end
        end
      rescue => e
        puts "Error writter Thread #{e}"
      end
    end
  end

  def send(uri,status,new_user)
    begin
      extChat = DRbObject.new_with_uri(uri)
      @users.push({:username => @current_rcv, :status => status ,:uri => uri}) if new_user
      if(status.eql?"offline")
        puts "User is offline"
        return
      end
      extChat.new_entry(@nickname, @current_rcv,@current_msg)
      extChat.print_msgs(@nickname)
    rescue => e
      puts "User is not available because #{e}, user will be removed from resolved users"
      for user in @users
        @users.delete(user) if user[:uri].eql?uri
      end
    end
  end

  def resolve_username user_entry
    user_entry = user_entry.strip.split("=> ")  
    @current_msg, @current_rcv = user_entry[0], user_entry[1] 
    for user in @users
      if user[:username].eql?user_entry[1]
        send(user[:uri],user[:status],false)
        return 
      end
    end
    @socket.write("to_s: translate #{user_entry[1]}\n")
  end

  def update_status(username,status)
    for user in @users
      if user[:username].eql?username
        user[:status] = status
        puts "#{username} is #{status}"
        return 
      end
    end
  end
end

