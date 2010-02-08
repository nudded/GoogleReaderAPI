module GoogleReader
  class Feed
    
    attr_reader :url, :title
    
    def initialize(hash,api)
      # strip the first 5 characters of the url (they are 'feed/')
      @url = hash['id'][5..-1]
      @title = hash['title']
      # no idea what this is used for
      @sortid = hash['sortid']
      @categories = hash['categories']
      @firstitemmsec = hash['firstitemmsec']
      
      @api = api
    end
    
    def unsubscribe
      @api.post_link 'api/0/subscription/edit' :s => "feed/#{url}",
                                               :ac => :unsubscribe
    end
    
    def unread_count
      entry = JSON[@api.cached_unread_count]['unreadcounts'].find {|h| h['id'] == "feed/#{url}"}
      entry ? entry['count'] : 0
    end
  
    def unread_items
      @api.get_link "atom/feed/#{url}", :xt => 'user/-/state/com.google/read'
    end    
    
    def inspect
      to_s
    end
    
    def to_s
      "<<Feed: #{title} url:#{url}>>"
    end
    
  end
end