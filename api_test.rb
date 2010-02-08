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
p user.subscriptions.unread_count
p user.subscriptions.total_unread
# user.subscriptions.add 'https://github.com/nudded.private.atom?token=944f906cf83622181c02f0d05ca467de'