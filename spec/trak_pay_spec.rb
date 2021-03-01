require_relative 'PaymentContent.rb'
describe TrakPay do
    let(:payees) {PaymentContent.payees()}
    let(:payee) {PaymentContent.payee()}
    let(:bank) {PaymentContent.payee_bank()}
    let(:new_payload) {TrakPay.new_payload(payee, bank, "Bearer #{PaymentContent.payment_object[:payment_secret]}")}
    it 'returns an array of payees from a payment cart_items object' do
        expect(payees).to be_an_instance_of(Array)
    end

    it 'expects return array value to have length' do
        expect(payees.empty?).to be false
    end

    it 'expects all payee entries to be valid' do
        valid = true
        payees.each do | pay |
            # test if array is nested
            if pay.class != Array
                valid = false
            end

        end
        expect(valid).to be true
    end

    it 'expects all payee groupings to have the same user_id' do
        valid = true

        payees.each do | pay |
            user_id = pay[0][:user_id]
            pay_filter = pay.select {| p | p[:user_id] == user_id}
            if pay_filter.length != pay.length
                valid = false
            end
            
            expect(valid).to be true

        end
    end

    it 'expects payee total to return float value' do 
        expect(TrakPay.payee_total(payee)).to be_an_instance_of(Float)
    end

    it 'expects payee total to equal 169.96' do
        expect(TrakPay.payee_total(payee)).to eq(169.96)

    end

    it 'expects new payload to return a hash with some keys' do
      expect(new_payload).to be_an_instance_of(Hash)
      expect(new_payload).to have_key(:beneficiary_name)
      expect(new_payload).to have_key(:account_bank)
      expect(new_payload).to have_key(:account_number)
      expect(new_payload).to have_key(:amount)
      expect(new_payload).to have_key(:narration)
      expect(new_payload).to have_key(:reference)
      expect(new_payload).to have_key(:currency)
      expect(new_payload).to have_key(:debit_currency)
    end
end