module GoogleReader

  BASE_URL = "http://www.google.com/reader/api/0/"
  
  # the main api
  class API
    
    require "user"
    require "json"
    
    # specify email and password in the arg hash
    def initialize(opthash)
      @user = GoogleReader::User.new(opthash)
    end
    
    # get the unread count for the current user
    def unread_count
      link = GoogleReader::BASE_URL + "unread-count"
      JSON[@user.get_request(link,:allcomments => true,:output => :json,:ck => Time.now.to_i)]
    end
    
  end
  
  
end