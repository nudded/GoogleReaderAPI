module GoogleReader
  
  class SubscriptionList
    
    require "feed"
    
    def initialize(api)
      @api = api
      update
    end

    def feeds
      @feeds
    end
    
    private
    
    def update
      fetch_list
    end
    
    def fetch_list
      json = JSON[@api.get_link 'api/0/subscription/list', :output => :json]['subscriptions']

      @feeds = json.map {|hash| GoogleReader::Feed.new(hash,@api) }
    end
    
  end
  
end