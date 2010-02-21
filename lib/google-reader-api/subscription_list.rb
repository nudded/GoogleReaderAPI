module GoogleReaderApi
  
  class SubscriptionList
    
    require "cgi"
    
    include GoogleReaderApi::RssUtils
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
     
    # yield each feed, if you return true
    # the feed will be removed from your subscriptions
    def remove_if
      each { |feed| feed.unsubscribe if yield feed}
      update
    end
    
    # subscribe to the given url
    # google will set the title for you
    def add(url)
      @api.post_link 'api/0/subscription/edit', :s => "feed/#{url}" , :ac => :subscribe 
      update
    end
    
    # return an array of unread items
    def unread_items
      feeds.map(&:all_unread_items)
    end
    
    # will return an array of entries with label
    def items_with_label(label)
      create_entries(@api.get_link "atom/user/-/label/#{CGI::escape label}")
    end

    def feeds
      @feeds
    end

    def each
      @feeds.each {|feed| yield feed}
    end
    
    def update
      fetch_list
    end

    private
    
    def fetch_list
      json = JSON[@api.get_link 'api/0/subscription/list', :output => :json]['subscriptions']
      @feeds = json.map {|hash| GoogleReaderApi::Feed.new(hash,@api) }
    end
    
  end
  
end