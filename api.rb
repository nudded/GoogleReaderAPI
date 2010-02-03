module GoogleReader

  # the main api
  class Api
    
    BASE_URL = "http://www.google.com/reader/api/0/"
    
    require "api_helper"
    require "json"
    
    include GoogleReader::ApiHelper
    
    attr_accessor :email,:password
    
    def initialize(email,password)
      @email, @password = email, password
    end
    
    def unread(feed_url=nil)
      feed_url = "/state/com.google/reading-list" if ! feed_url
      feed = fetch_unread['unreadcounts'].find {|e| e['id'] =~ Regexp.new(feed_url)}
      feed ? feed['count'] : 0
    end

    def user_info
      @user_info ||= fetch_user_info
    end
    
    private
    
    # will return the json object for the unread_request
    def fetch_unread
      get_link "unread-count" , :allcomments => true,:output => :json,:ck => Time.now.to_i
    end
    
    def fetch_user_info
      get_link "user-info" ,:ck => Time.now.to_i
    end
    
    def get_link(link,args={})
      link = BASE_URL + link
      JSON[get_request(link,args)]
    end
    
  end

end