module GoogleReader
  module RssUtils 
    
    require "rss/parser"
    require "rss/atom"
    require "entry"

    private

    def create_entries(atom_feed)
      RSS::Parser.parse(atom_feed).entries.map {|e| GoogleReader::Entry.new(@api,e) }
    end
    
  end
end