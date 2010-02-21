module GoogleReaderApi
  class Cache
    
    def initialize(time)
      @time = time
      @hash = {}
    end
    
    def [](key)
      if cached?(key)
        @hash[key].first
      else
        @hash[key] = nil
      end
    end
    
    def []=(key,value)
      @hash[key] = [value,Time.now.to_i]
    end
    
    def cached?(key)
      if @hash[key]
        Time.now.to_i - @hash[key][1] < @time
      else
        false
      end
    end
    
  end
end