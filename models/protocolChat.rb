require 'chatClient'

module ProtocolChat

  @@status = %w[online offline busy away]
  @@users = []

  def eval_msg(umsg,sock)
    umsg = umsg.strip
    msg = umsg.split
    puts umsg
    case msg[0]
    when "register_info:"
      register_user(umsg,sock)
    when "to_server:"
      response(umsg,sock)
    end
  end

  def register_user(user_info,sock)
    user_info = user_info.split
    flat = true
    # for user in @@users
    #  if(user_info[1].eql? user[:username])
    #    sock.write("#{user[:username]} already exist, write quit and try with another username\n")
    #    flat = false
    #    break
    #  end
    #end 
    if flat
      @@users.push({:username => user_info[1], :status => user_info[2], :address => user_info[3]}) 
      puts "#{user_info[1]} information was saved"
      sock.write("#{user_info[1]} , your registration was successfully\n")
    end
  end

  def response(msg,sock)
    begin 
      msg = msg.split
      case msg[1]
      when "directory"
        sock.write("#{list_to_print('Available users',@@users)}\n")
      when "translate"
        translate(msg,sock)
      when "help"
        sock.write("Available commands: directory\n")
      when "status"
        change_status(msg[2],sock)
      else
        sock.write("I dont know what do you want\n")
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
    @@users[@descriptors.index(sock)-1][:status] = status
    sock.write("Now your status is #{status}\n")
  end
    
  def list_to_print(title,list)
    line = "" 
    1.upto(title.size){line << "-"}
    title = title + "\n" + line + "\n"
    return title + (list.collect {|x| " => #{x}" }).join("\n")
  end
  
end