root = File.dirname(__FILE__)
$:.unshift root + "/models"

require "dirServer"

unless ARGV.length == 2
  STDERR.puts "Usage: #{$0} <host> <port>"
  exit 1
end

$host, $port = ARGV
server = DirServer.new($host,$port)
server.run