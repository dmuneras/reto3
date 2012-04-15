require 'drb/drb'

class Chat
  
  include DRb::DRbUndumped
  attr_accessor :buffer, :address
  
  def initialize
    self.buffer = []
    DRb.start_service(nil, self)
    addrs = DRb.uri.gsub(/\/\/(.*):/,"//"+local_ip+":")
    self.address = addrs
  end
    
  def new_entry(nickname,current_rcv,msg)
    @buffer.push({:from => nickname, :to => current_rcv, :msg => msg, :time => Time.now, :read => false})
  end
    
  def print_msgs(owner)
    for msg in @buffer 
      if msg[:read] == false
        puts "~> #{msg[:from]} said at #{msg[:time].strftime('%B %d , %H:%M:%S')} => #{msg[:msg]}" 
        msg[:read] = true
      end
    end
  end
  
  def local_ip
    orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true
    UDPSocket.open do |s|
      s.connect '64.233.187.99', 1
      s.addr.last
    end
  ensure
    Socket.do_not_reverse_lookup = orig
  end

  def stop
    DRb.stop_service
  end
end

