root = File.dirname(__FILE__)
$:.unshift root + "/models"

require "chatClient"
unless ARGV.length == 5
  STDERR.puts "Usage: #{$0} <nickname> <host> <port> <status> <address>"
  STDERR.puts "Available status :\n1.online.\n2.offline.\n3.away"
  STDERR.puts "Example address: druby://localhost:8787"
  exit 1
end

$nickname, $host, $port, $status , $address = ARGV
unless %W[online offline away].include?($status)
  STDERR.puts "Wrong Status, the availables status are online, offline, away"
  exit 1
end

unless $address =~ /druby:/
  STDERR.puts "The address has to be like druby://localhost:8787, druby://<host>:<port>"
  exit 1
end

chatClient = ChatClient.new($nickname,$host,$port,$status, $address)


