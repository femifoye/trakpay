
require 'faraday_connect/faraday_connect'
require 'json'

module FlutterwavePayment
    class Pay
        def initialize(secret, payload, amt)
            @secret_key = secret
            @payload = payload
            @amount = amt

        end
    
        def secret
            @secret_key
        end

        def payload
            @payload
        end

        def amount
            @amount
        end

        def payout
            # change payload amount
            @payload["amount"] = @amount
            # initiate transfer to bank account
            url = 'https://api.flutterwave.com/v3/transfers'
            connection = FaradayConnect.connection(url)
            data = connection.post(url) do | request |
                token = "Bearer "+@secret_key
                request.headers["Authorization"] = token
                request.headers["Content-Type"] = 'application/json'
                request.body = @payload.to_json
            end
            JSON.parse(data.body, symbolize_names: true)    
        end
    end  
end