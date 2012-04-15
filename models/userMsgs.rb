module UserMsgs

  def user_help
    return "To send message to de server. write: to_s: <command> , to send message to an user, <msg> => <username>"
  end

  def connecting host
    return "Trying to connect: " + host  
  end

  def nothing_to_send
    return "Please enter something to send"
  end

  def server_down
    return "Server down, please enter quit"
  end

  def wrong_command
    return "I dont know what are you trying say"
  end
  
  def user_already_exits user 
   return "#{user} already exist, write quit and try with another username"
  end
  
  def list_to_print(title,list)
    line = "" 
    1.upto(title.size){line << "-"}
    title = title + "\n" + line + "\n"
    return title + (list.collect {|x| " ~> #{x}" }).join("\n")
  end

  def users_list users
    return "    User's List\n    =======\n" +
      (users.collect {|user| "    ~~> #{user[:username]}(#{user[:status]})"}).join("\n")
  end
end