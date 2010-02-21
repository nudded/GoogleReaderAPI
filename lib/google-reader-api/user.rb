module GoogleReaderApi
  
  class User
    
    require "json"
    # maybe someone would like to access the api for a user
    attr_reader :api
    
    def initialize(email,password)
      @api = GoogleReaderApi::Api::new email,password
    end
    
    def info
      JSON[api.get_link "api/0/user-info"]
    end
    
    def subscriptions
      @subscriptions ||= GoogleReaderApi::SubscriptionList.new @api
    end
    
    def feeds
      subscriptions.feeds
    end
    
  end
end
