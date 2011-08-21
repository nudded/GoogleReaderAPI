module GoogleReaderApi

  class Api

    require "cgi"
    require "net/https"
    require "uri"

    BASE_URL = "http://www.google.com/reader/"

    # specify either the :email and :password or the :auth token you got in the past
    #
    # [:email] the user's email address for login purposes
    #
    # [:password] the user's password for login purposes
    #
    # [:auth]  the auth token you got from a previous authentication request
    #          if you provide this you do not need to provide the email and password
    def initialize(options)
      if options[:auth]
        @auth = options[:auth]
      else
        request_auth(options[:email],options[:password])
      end
      @cache = GoogleReaderApi::Cache.new(2)
    end

    # do a get request to the link
    # args is a hash of values that should be used in the request
    def get_link(link,args={})
      link = BASE_URL + link
      get_request(link,args)
    end

    def post_link(link,args={})
      link = BASE_URL + link
      post_request(link,args)
    end

    def cached_unread_count
      @cache['unread-count'] ||= get_link 'api/0/unread-count', :output => :json
    end

    private

    # url as a string
    # the post data as a hash
    def post_request(url,args)
      uri = URI.parse(url)
      req = Net::HTTP::Post.new(uri.path)
      req.set_form_data(args)
      request(uri,req)
    end

    # the url as a string and the args as a hash
    # e.g. :allcomments => true etc...
    def get_request(url,args)
      uri = URI.parse url

      # ck is the current unix timestamp
      args[:ck] = Time.now.to_i unless args[:ck]

      req = Net::HTTP::Get.new("#{uri.path}?#{argument_string(args)}")
      request(uri,req)
    end

    def request(uri,request)
      # add the cookie to the http header
      request.add_field('Authorization',"GoogleLogin auth=#{auth}")
      res = Net::HTTP.start(uri.host,uri.port) do |http|
        http.request(request)
      end
      # TODO: use better exception
      if res.code != '200'
        p res.body
        raise "something went wrong"
      end
      res.body
    end

    # returns the argumentstring based on the hash it is given
    def argument_string(args)
      args.to_a.map { |v| v.join '=' }.join('&')
    end

    def auth
      @auth
    end

    def request_auth(email,password)
      login = GoogleLogin::ClientLogin.new :service => 'reader', :source => 'nudded-greader-0.1'
      login.authenticate email, password
      @auth = login.auth
    end

  end

end
