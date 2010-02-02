module GoogleReader
  
  # use this class to make api calls
  # either use get or post (depending on your needs)
  class User
    
    require "cgi"
    require "net/https"
    require "uri"
    
    attr_accessor :email ,:password
    
    def initialize(opthash={})
      @email = opthash[:email]
      @password = opthash[:password]
    end
    
    # the url as a string and the args as a hash
    # e.g. :allcomments => true etc...
    def get_request(url,args)
      uri = URI.parse url
      req = Net::HTTP::Get.new("#{uri.path}?#{argument_string(args)}")
      request(uri,req)
    end
    
    # url as a string
    # the post data as a hash
    def post_request(url,args)
      uri = URI.parse(url)
      args[:T] = token
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(args)
      request(uri,req)
    end
    
    private

    def request(uri,request)
      # add the cookie to the http header
      request.add_field('Cookie',user_cookie)
      res = Net::HTTP.start(uri.host,uri.port) do |http|
        http.request(request)
      end
      # TODO: use better exception
      raise "something went wrong" if res.code != '200'
      res.body
    end

    # returns the argumentstring based on the hash it is given
    def argument_string(args)
      CGI.escape(args.to_a.map { |v| "#{v[0]}=#{v[1]}" }.join('&'))
    end
   
    def token
      url = URI.parse "http://www.google.com/reader/api/0/token"
      res = Net::HTTP.start(url.host,url.port) do |http|
        http.get(url.path,"Cookie" => user_cookie)
      end
      res.body
    end

    def user_cookie
      CGI::Cookie::new('name' => 'SID' , 'value' => sid , 
                       'path' => '/' , 'domain'  => '.google.com').to_s
    end

    def sid
      @sid ||= request_sid
    end
    
    def request_sid
      url = URI.parse "https://www.google.com/accounts/ClientLogin?service=reader&Email=#{email}&Passwd=#{password}"
      http = Net::HTTP.new(url.host,url.port)
      http.use_ssl = true
      res,data = http.get("#{url.path}?#{url.query}")

      raise "could not authenticate" if res.code != "200"
      
      data.match(/SID=(.+?)\n/)[1]
      
    end
    
  end
  
end