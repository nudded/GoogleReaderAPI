module GoogleReader
  
  class SubscriptionList
    
    require "feed"
    require "rss_utils"
    
    include RssUtils
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
    
    # subscribe to the given url
    # optionally provide a title, otherwise I will try and parse it
    def add(url,title=nil)
      title ||= parse_title(url)
      p title
      @api.post_link 'api/0/subscription/edit', :s => "feed/#{url}" ,
                                                :ac => :subscribe ,
                                                :title => title
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