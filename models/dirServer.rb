require "socket"
require "protocolChat"

class DirServer
  include ProtocolChat

  def initialize( host,port )
    @descriptors = []
    @serverSocket = TCPServer.new( host, port )
    @serverSocket.setsockopt( Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1 )
    printf("dirServer started on port %d\n", port)
    @descriptors.push( @serverSocket )
  end 

  def run
    while true
      begin
        res = select( @descriptors, nil, nil)
        if res != nil 
          for sock in res[0]
            if sock == @serverSocket 
              accept_new_connection
            elsif sock.eof? 
              sock.close
              @descriptors.delete(sock)
            else
              umsg = sock.gets()
              eval_msg(umsg,sock)
            end
          end
        end
      rescue => e
        puts "Somenthing wrong happened #{e}"
      end
    end
  end 

  private
  def accept_new_connection
    newsock = @serverSocket.accept
    @descriptors.push( newsock )
  end   
end