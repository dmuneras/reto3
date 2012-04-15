require 'chatClient'
require 'userMsgs'
module ProtocolChat

  include UserMsgs
  @@status = %w[online offline busy away]
  @@commands = %W[ users help status ]
  @@users = []

  def eval_msg(umsg,sock)
    umsg = umsg.strip
    msg = umsg.split
    puts umsg
    case msg[0]
    when "register_info:"
      register_user(umsg,sock)
    when "to_s:"
      response(umsg,sock)
    end
  end

  def register_user(user_info,sock)
    user_info = user_info.split
    for user in @@users
      if(user_info[1].eql? user[:username])
        sock.write("#{user_already_exits user[:username]}\n")
        return
      end
    end 
    @@users.push({:username => user_info[1], :status => user_info[2], :address => user_info[3]}) 
    puts "#{user_info[1]} information was saved"
    sock.write("Welcome #{user_info[1]}\n")   
  end

  def response(msg,sock)
    begin 
      msg = msg.split
      case msg[1]
      when "users"
        sock.write("#{users_list(@@users)}\n")
      when "translate"
        translate(msg,sock)
      when "help"
        sock.write("#{list_to_print('Available commands', @@commands)}\n")
      when "status"
        change_status(msg[2],sock)
      else
        sock.write("#{wrong_command}\n")
      end
    rescue Exception => e
      puts "Exception #{e}"
    end
  end
   
  def translate(msg,sock)
    username = msg[2]
    for user in @@users
      if(username.eql? user[:username])
        sock.write("translate: #{user[:address]}\n")
      end
    end
  end
  
  def change_status(status,sock)
    if @@status.include? status
      @@users[@descriptors.index(sock)-1][:status] = status
      sock.write("Now your status is #{status}\n")
    else
      sock.write("Wrong status, #{list_to_print('Available status', @@status)}")
    end
  end
    
end