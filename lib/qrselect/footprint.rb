module QRSelect
  class Footprint
    def initialize
      @footprint = {}
    end

    def visit(url)
      @footprint[url] = true
    end
    
    def visited?(url)
      @footprint.key?(url)
    end
  end
end
