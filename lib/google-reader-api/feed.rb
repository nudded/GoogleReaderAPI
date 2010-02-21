module GoogleReaderApi
  
  class Feed
  
    include GoogleReaderApi::RssUtils
    
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
      @api.post_link 'api/0/subscription/edit' , :s => "feed/#{url}",
                                                 :ac => :unsubscribe
    end
    
    def unread_count
      entry = JSON[@api.cached_unread_count]['unreadcounts'].find {|h| h['id'] == "feed/#{url}"}
      entry ? entry['count'] : 0
    end
    
    # return count read items
    def read_items(count=20)
      create_entries get_user_items('read',:n => count)
    end
    
    def starred_items(count=20)
      create_entries get_user_items('starred',:n => count)
    end
    
    # return the number of specified items. (read or not)
    def items(count = 20)
      create_entries get_feed_items(:n => count)
    end
    
    # return all the unread items in an array
    def all_unread_items
      unread_items(unread_count)
    end
    
    # will return an array of GoogleReader::Feed::Entry objects.
    # will try to return the amount of unread items you specify. unless there are no more.
    # will return 20 unread items by default.
    def unread_items(count = 20)
      create_entries get_feed_items(:n => count,:xt => 'user/-/state/com.google/read')
    end
    
    def inspect
      to_s
    end
    
    def to_s
      "<<Feed: #{title} url:#{url}>>"
    end
    
    private
    
    def get_user_items(state,args={})
      @api.get_link "atom/user/-/state/com.google/#{state}" , args
    end
    
    def get_feed_items(args={})
      @api.get_link "atom/feed/#{url}" , args
    end

  end
end