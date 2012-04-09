require 'drb/drb'

class Chat
  
  include DRb::DRbUndumped
  attr_accessor :buffer, :address
  
  def initialize(addr)
    self.buffer = []
    self.address = addr 
    DRb.start_service(addr, self)
    puts "Chat service started on address #{addr}"
  end
    
  def new_entry(nickname,current_rcv,msg)
    @buffer.push({:from => nickname, :to => current_rcv, :msg => msg, :time => Time.now, :read => false})
  end
  
  def print_msgs(owner)
    for msg in @buffer 
      if msg[:read] == false
        puts "#{msg[:from]} says at #{msg[:time]} => #{msg[:msg]}" 
        msg[:read] = true
      end
    end
  end
  
  def stop
    DRb.stop_service
  end
end

