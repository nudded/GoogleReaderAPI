module GoogleReaderApi
  module RssUtils
    
    require "rss/parser"
    require "rss/atom"

    private

    def create_entries(atom_feed)
      RSS::Parser.parse(atom_feed.force_encoding('utf-8')).entries.map {|e| GoogleReaderApi::Entry.new(@api,e) }
    end
    
  end
end