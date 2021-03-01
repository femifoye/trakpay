require 'faraday_connect/faraday_connect'
require 'flutterwave_payment/flutterwave_payment'
require 'json'
require 'securerandom'

module TrakPay
    def self.payees(items)
        payees = []
        for item in items do
            append = true
            if payees.length <= 0
                payees.push([item])
            else
                for grp in payees
                    group = grp.select{|g| g[:user_id] == item["user_id"]}
                    if group.length > 0
                        grp.push(item)
                        append = false
                    end
                end

                if append
                    payees.push([item])
                end
            end
        end
        return payees
    end

    # def self.wallet_balance

    # end

    def self.payee_total(payee)
        total = 0
        payee.each do | pay |
            total += pay[:license][:price].to_f
        end
        return total
    end

    def self.new_payload(payee, bank, secret)
        bank_code = self.get_account_bank(bank[:name], secret, "NG")
        currency = "NGN"
        return {
            :beneficiary_name => bank[:account_name],
            :account_bank => bank_code,
            :account_number => bank[:account_number],
            :amount => nil,
            :narration => "Payment for a track on Trakjungle",
            :reference => self.generate_reference(),
            :currency => currency,
            :debit_currency => "USD" 
        }
    end

    def self.process_payment(payment)
        percent_off = 0
        final_amt = nil
        amt_after_processing_fee = payment[:total] - (( payment[:processing_fee] / 100) * payment[:total])
        if payment[:subscription][:plan] == "FREE"
            percent_off = 20.0
            final_amt = amt_after_processing_fee - ( ( percent_off / 100 ) * amt_after_processing_fee )

        elsif payment[:subscription][:plan] == "FLEX"
            percent_off = 5.0
            final_amt = amt_after_processing_fee - ( ( percent_off / 100 ) * amt_after_processing_fee )
        else
            final_amt = amt_after_processing_fee
        end
        # process payout with flutterwave
        pay = FlutterwavePayment::Pay.new(payment[:secret_key], payment[:payload], final_amt)
        pay.payout()
    end

    def self.get_account_bank(bank, secret, country)
        url = "https://api.flutterwave.com/v3/banks/#{country}"
        connection = FaradayConnect.connection(url)
        resp = connection.get(url) do | request |
            request.headers["Authorization"] = secret
            request.headers["Content-Type"] = 'application/json'
            request.body = { :country => country }.to_json
        end
        data = JSON.parse(resp.body)
        bank_obj = data["data"].select {| b | b["name"] == bank }
        
        bank_obj[0]["code"]
    end

    def self.generate_reference
        "TRKPYOT-"+SecureRandom.hex(10)+"-#{Time.now.to_i}"
    end
end