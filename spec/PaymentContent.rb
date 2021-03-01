require 'flutterwave_payment/flutterwave_payment'
require 'trak_pay/trak_pay'

module PaymentContent
    def self.cart_items
        return [
            { 
              id: 1,
              name: "Beach",
             license: {
               name: "Premium",
               price: "19.99",
             },
             user_id: 8
            },
            { 
              id: 2,
              name: "Beaching",
             license: {
               name: "Premium",
               price: "49.99",
             },
             user_id: 3
            },
            { 
              id: 3,
              name: "Prom",
             license: {
               name: "Basic",
               price: "5.99",
             },
             user_id: 3
            },
            { 
              id: 4,
              name: "Promers",
             license: {
               name: "Basic",
               price: "9.99",
             },
             user_id: 1
            },
            { 
              id: 5,
              name: "Sample",
             license: {
               name: "Premium",
               price: "59.99",
             },
             user_id: 8
            },
            { 
              id: 6,
              name: "Sunset",
             license: {
               name: "Premium",
               price: "79.99",
             },
             user_id: 8
            },
            { 
              id: 7,
              name: "Sunrise",
             license: {
               name: "Premium",
               price: "99.99",
             },
             user_id: 3
            },
            { 
              id: 8,
              name: "Blank",
             license: {
               name: "Basic",
               price: "19.99",
             },
             user_id: 3
            },
            { 
              id: 9,
              name: "Blanket",
             license: {
               name: "Basic",
               price: "19.99",
             },
             user_id: 1
            },
            { 
              id: 10,
              name: "Fin",
             license: {
               name: "Basic",
               price: "9.99",
             },
             user_id: 8
            }
        ]
    end

    def self.sorted_payees
        return [
            [
                {:id=>1, :name=>"Beach", :license=>{:name=>"Premium", :price=>"19.99"}, :user_id=>8},
                {:id=>5, :name=>"Sample", :license=>{:name=>"Premium", :price=>"59.99"}, :user_id=>8},
                {:id=>6, :name=>"Sunset", :license=>{:name=>"Premium", :price=>"79.99"}, :user_id=>8},
                {:id=>10, :name=>"Fin", :license=>{:name=>"Basic", :price=>"9.99"}, :user_id=>7}
            ], 
            [
                {:id=>2, :name=>"Beaching", :license=>{:name=>"Premium", :price=>"49.99"}, :user_id=>3},
                {:id=>3, :name=>"Prom", :license=>{:name=>"Basic", :price=>"5.99"}, :user_id=>3},
                {:id=>7, :name=>"Sunrise", :license=>{:name=>"Premium", :price=>"99.99"}, :user_id=>3},
                {:id=>8, :name=>"Blank", :license=>{:name=>"Basic", :price=>"19.99"}, :user_id=>3}
            ], 
            [
                {:id=>4, :name=>"Promers", :license=>{:name=>"Basic", :price=>"9.99"}, :user_id=>1},
                {:id=>9, :name=>"Blanket", :license=>{:name=>"Basic", :price=>"19.99"}, :user_id=>1}
            ]
        ]
    end

    def self.payees
        TrakPay.payees(self.cart_items)
    end

    def self.payee
        self.sorted_payees[0]
    end

    def self.payment_object
        return {
            :payee_id => 43,
            :payload => {
                "beneficiary_name" => "John Doe",
                "account_bank" => "044",
                "account_number" => "0690000031",
                "amount" => nil,
                "narration" => "Payment for a track on Trakjungle",
                "reference" => "khlm-pstmnpyt-rfxx007_PMCKD_1",
                "currency" => "NGN",
                "debit_currency" => "USD"
            },
            :total => 169.96,
            :subscription => {
                :id => 29, 
                :amount => 0.0, 
                :charge => {"plan"=>"free"}, 
                :user_id => 43, 
                :currency => "n/a", 
                :plan => "FREE"
            },
            :processing_fee => 3.8,
            :payment_secret => "xxxxxxxxxxxxxxxxxxxxxxxxxx"
        }
    end

    def self.payee_bank
        return {   
            id: 4, 
            name: "Access Bank", 
            branch: "null", 
            account_name: "John Doe", 
            user_id: 29, 
            country: "Nigeria", 
            account_number: "0690000031"
        }
    end

    def self.flutterwave_payment
        return FlutterwavePayment::Pay.new(
            payment_object[:payment_secret], 
            payment_object[:payload], 
            132.25
        )
    end
end