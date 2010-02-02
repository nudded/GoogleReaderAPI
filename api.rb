module GoogleReader

  # the main api
  class API
    
    BASE_URL = "http://www.google.com/reader/api/0/"
    
    require "user"
    require "json"
    
    # specify email and password in the arg hash
    def initialize(opthash)
      @user = GoogleReader::User.new(opthash)
    end
    
    # get the unread count for the current user
    def unread_count
      json = fetch_unread
      if json['unreadcounts'].first
        json['unreadcounts'].first['count']
      else
        0
      end
    end
    
    def unread
      fetch_unread['unreadcounts']
    end
    
    private
    
    # will return the json object for the unread_request
    def fetch_unread
      link = BASE_URL + "unread-count"
      JSON[@user.get_request(link,:allcomments => true,:output => :json,:ck => Time.now.to_i)]
    end
    
  end

end