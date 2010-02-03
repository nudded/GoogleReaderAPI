require "api"
# well, this is ugly, I know
print "type in your password: "
`stty -echo`
pass = gets.chomp
`stty echo`
puts

api = GoogleReader::Api.new 'willemstoon@gmail.com', pass
p api.unread_count
p api.unread
p api.user_info