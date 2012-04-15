root = File.dirname(__FILE__)
$:.unshift root + "/models"

require "chatClient"
unless ARGV.length == 4
  STDERR.puts "Usage: #{$0} <nickname> <host> <port> <status>"
  STDERR.puts "Available status :\n1.online.\n2.offline.\n3.away"
  exit 1
end

$nickname, $host, $port, $status = ARGV
unless %W[online offline away].include?($status)
  STDERR.puts "Wrong Status, the availables status are online, offline, away"
  exit 1
end

chatClient = ChatClient.new($nickname,$host,$port,$status)


