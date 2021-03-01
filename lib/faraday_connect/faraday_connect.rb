require 'faraday'

module FaradayConnect
    def self.connection(url)
        return Faraday.new(:url => url) do |c|
            c.request :url_encoded
            c.response :logger
            c.adapter :net_http
         end
    end
end