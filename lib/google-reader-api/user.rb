module GoogleReaderApi
  
  class User
    
    require "json"
    # maybe someone would like to access the api for a user
    attr_reader :api

    # specify either the :email and :password or the :auth token you got in the past
    #
    # [:email] the user's email address for login purposes
    #
    # [:password] the user's password for login purposes
    #
    # [:auth]  the auth token you got from a previous authentication request
    #          if you provide this you do not need to provide the email and password
    def initialize(options)
      @api = GoogleReaderApi::Api::new options
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
