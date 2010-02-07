require "user"
# well, this is ugly, I know
print "type in your password: "
`stty -echo`
pass = gets.chomp
`stty echo`
puts

user = GoogleReader::User.new 'willemstoon@gmail.com', pass
# p user.info
# p user.subscriptions.feeds
puts user.subscriptions.feeds[5].unread_count
sleep 5
puts user.subscriptions.feeds[5].unread_count
sleep 12
puts user.subscriptions.feeds[5].unread_count