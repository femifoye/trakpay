
require_relative 'PaymentContent.rb'

describe FlutterwavePayment do
    let(:payment_response) { PaymentContent.flutterwave_payment.payout() }
    let(:payment_secret) { PaymentContent.flutterwave_payment.secret() }
    let(:payment_payload) { PaymentContent.flutterwave_payment.payload() }
    let(:payment_amount) { PaymentContent.flutterwave_payment.amount() }

    it 'expects FlutterwavePayment::Pay secret key to exist' do
        expect(payment_secret).to be_an_instance_of(String)
    end

    it 'expects FlutterwavePayment::Pay payload to be instance of Hash' do
        expect(payment_payload).to be_an_instance_of(Hash)
    end

    it 'expects FlutterwavePayment::Pay amount to be instance of Float' do
        expect(payment_amount).to be_an_instance_of(Float)
    end

    # it 'expects FlutterwavePayment::Pay payout to return some data correctly' do
    #     expect(payment_response).to be_an_instance_of(Hash)
    #     expect(payment_response).to have_key(:status)
    #     expect(payment_response).to have_key(:message)
    #     expect(payment_response).to have_key(:data)
    # end


end
