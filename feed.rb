module GoogleReader
  
  class Feed
  
    require "rexml/document"
    
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
  
    def unread_items(count = 20)
      atom_feed = @api.get_link "atom/feed/#{url}", :n => count, :xt => 'user/-/state/com.google/read', :c => @continuation
      parse_continuation(atom_feed)
      # for now
      atom_feed
    end
    
    def inspect
      to_s
    end
    
    def to_s
      "<<Feed: #{title} url:#{url}>>"
    end
    
    private
    
    def parse_continuation(atom_feed)
      # we parse the xml, looking for the continuation field.
      element = REXML::Document.new(atom_feed).elements.first.elements['gr:continuation']
      # if we found it, save the value else put nil in it.
      @continuation = element ? element.text : nil
    end
    
    
  end
end