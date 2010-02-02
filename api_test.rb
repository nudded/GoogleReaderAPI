require "api"
# well, this is ugly, I know
print "type in your password: "
`stty -echo`
pass = gets.chomp
`stty echo`
puts

api = GoogleReader::API.new(:email=>'willemstoon@gmail.com',:password => pass)
p api.unread_count
