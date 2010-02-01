require "user"
require "uri"

# well, this is ugly, I know
print "type in your password: "
`stty -echo`
pass = gets.chomp
`stty echo`
puts
temp = GoogleReader::User.new(:email => "willemstoon@gmail.com",:password => pass)
link = "http://www.google.com/reader/api/0/unread-count"
p temp.get_request(link,:allcomments => true,:output => :json,
                                    :ck => Time.now.to_i)
                    
link = "http://www.google.com/reader/api/0/subscription/edit"                
p temp.post_request(link,:s => "feed/http://blog.martindoms.com/feed/",:ac=>:subscribe,:t=>"testing")
