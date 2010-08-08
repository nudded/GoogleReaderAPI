require "net/https"
require "uri"

module GoogleLogin  

  # == ClientLogin
  # 
  # Use this Class to get an auth-token
  class ClientLogin
    
    # Base Exception class 
    LoginError = Class.new Exception    

    # All the possible exceptions
    [
      "BadAuthentication", 
      "NotVerified", 
      "TermsNotAgreed", 
      "CaptchaRequired", 
      "Unknown", 
      "AccountDeleted",
      "AccountDisabled",   
      "ServiceDisabled",
      "ServiceUnavailable",
    ].each do |const|
      const_set const, Class.new(LoginError)
    end
   
    DEFAULTS = { 
      :accountType => 'HOSTED_OR_GOOGLE' ,
      :source => 'companyName-applicationName-versionID',
      :service => 'service-identifier'
    }  
    
    attr_reader :auth, :sid, :lsid, :captcha_url
    
    # specify the :service, :source and optionally :accountType
    # 
    # [:service] the service identifier, check the google api documentation.
    #
    # [:source] the name of your application. String should be in the form
    #           "companyName-applicationName-versionID".
    #
    # [:accountType]  one of the following values: 
    #                 "GOOGLE", "HOSTED", "HOSTED_OR_GOOGLE" (default if none 
    #                 given)
    def initialize(arghash = {})
      @options = DEFAULTS.merge arghash
    end
    
    # authenticate a user, which sets the auth, sid and lsid instance_variables
    # if you provide a block, it will be called with a captcha url if google 
    # forces you to answer the captcha. Make sure you return the anwer in the block.
    # 
    # if no block is given, this will raise a CaptchaRequired error.
    # you can rescue them and show the url via the captcha_url method.
    # 
    # you can then call authenticate and as 3rd parameter you provide the
    # captcha answer.
    # 
    # all Exceptions this raises are subclasses of ClientLogin::LoginError.
    # so make sure you handle them.
    # 
    # This is a list of all the possible errors and their meaning
    # Error code::	Description
    # BadAuthentication::   The login request used a username or password that is not recognized.
    # NotVerified::         The account email address has not been verified. The user will need to access their Google account directly to resolve the issue before logging in using a non-Google application.
    # TermsNotAgreed::      The user has not agreed to terms. The user will need to access their Google account directly to resolve the issue before logging in using a non-Google application.
    # CaptchaRequired::     A CAPTCHA is required. (A response with this error code will also contain an image URL and a CAPTCHA token.)
    # Unknown::             The error is unknown or unspecified; the request contained invalid input or was malformed.
    # AccountDeleted::      The user account has been deleted.
    # AccountDisabled::     The user account has been disabled.
    # ServiceDisabled::     The user's access to the specified service has been disabled. (The user account may still be valid.)
    # ServiceUnavailable::  The service is not available; try again later.
    def authenticate(username, password, captcha_response = nil)
      @options[:Email], @options[:Passwd] = username, password
      # set logincaptcha, captchatoken will already be set
      @options[:logincaptcha] = captcha_response if captcha_response

      parse_response perform_request
      
    rescue CaptchaRequired
      if block_given?
        @options[:logincaptcha] = yield captcha_url
        retry
      else
        raise CaptchaRequired
      end
    end
    
    private
    
    def perform_request
      request = Net::HTTP::Post.new '/accounts/ClientLogin'
      request.form_data = @options
      
      https = Net::HTTP.new 'www.google.com', 443 
      https.use_ssl = true
      
      https.request request
    end
    
    def parse_body(response_body)
      response_body.scan(/(\w+)=(.+)\n/).each do |key, value|
        instance_variable_set "@#{key.downcase}" , value
      end
    end
    
    def parse_response(response)
      if response.code_type == Net::HTTPOK
        parse_body response.body
      else
        handle_error response.body
      end
    end
    
    
    def handle_error(response_body)
      error_message = response_body.match(/Error=(\w+)\n/)[1].strip
      
      if error_message == "CaptchaRequired"
        @options[:logintoken] = response_body.match(/CaptchaToken=(.+)\n/)[1]
        self.captcha_url = response_body.match(/CaptchaUrl=(.+)\n/)[1]
      end
      
      raise_error_class error_message
    end
    
    def raise_error_class(error_message)
      raise self.class.const_get error_message
    end
    
    def captcha_url=(url)
      @captcha_url = "http://www.google.com/accounts/" << url
    end
    
  end
  
end
