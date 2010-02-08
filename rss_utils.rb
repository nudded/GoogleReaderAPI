module GoogleReader
  module RssUtils 
    require "rss/atom"
    require "net/http"
    require "hpricot"

    private

    def parse_title(url)
      rss = fetch_rss(url)
      Hpricot::XML(rss).at('title').inner_text
      # if anything goes wrong, return the empty string
    rescue
      ''
    end

    def fetch_rss(url)
      uri = URI.parse url
      Net::HTTP.start(uri.host,uri.port) do |http|
        http.get(uri.path).body
      end
    end
  end
end