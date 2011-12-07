require 'yaml'

module QRSelect
  module Config
    @initialized = false

    def self.initialized?
      @initialized
    end

    def self.load(filepath)
      yaml = YAML.load_file(filepath)
      yaml.each do |k, v|
        Config.const_set(k.upcase, v)
      end
      @initialized = true
    end

    def self.init(params)
      params.each do |k, v|
        Config.const_set(k.upcase, v)
      end    
      @initialized = true
    end
  end
end
