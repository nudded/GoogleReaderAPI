module GoogleReader
  module RssUtils 
    require "rss/atom"
    require "net/http"
    require "net/https"
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
      http = Net::HTTP.new(uri.host,uri.port) 
      http.use_ssl = true if uri.scheme == 'https'
      http.get(uri.request_uri).body
    end
  end
end