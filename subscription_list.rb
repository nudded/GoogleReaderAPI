module GoogleReader
  
  class SubscriptionList
    
    require "feed"
    
    include Enumerable
    
    def initialize(api)
      @api = api
      update
    end
    
    # returns the total unread count
    def total_unread
      inject(0) {|i,j| i+j.unread_count}
    end
    
    # returns a hash
    # with following pattern:
    # feed => unread_count
    def unread_count
      hash = {}
      each { |feed| hash[feed] = feed.unread_count }
      hash
    end
    
    def feeds
      @feeds
    end

    def each
      @feeds.each {|feed| yield feed}
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