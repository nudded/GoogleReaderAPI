module GoogleReader
  
  class User
    
    require "api_helper"
    include ApiHelper
    
    def initialize(email,password)
      @email,@password = email,password
    end
    
    def info
      @api.user_info
    end

    
    
  end
  
end
