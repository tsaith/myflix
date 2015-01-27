require 'spec_helper'

describe StripeWrapper::Charge do
  before do
    StripeWrapper.set_api_key
  end

  let(:token) do
    Stripe::Token.create(
      :card => {
        :number => card_number,
        :exp_month => 1,
        :exp_year => 2016,
        :cvc => "314",
        :description => "paid by someone."
      }
    ).id
  end

  context "with valid card" do
    let(:card_number) { '4242424242424242' }
    it "charges the card successfully", :vcr do
      response = StripeWrapper::Charge.create(amount: 300, card: token)
      expect(response).to be_successful
    end
  end

  context "with invalid card" do
    let(:card_number) { '4000000000000002' }

    it "does not charge the card successfully", :vcr do
      response = StripeWrapper::Charge.create(amount: 300, card: token)
      expect(response).not_to be_successful
    end
    it "contains an error message", :vcr do
      response = StripeWrapper::Charge.create(amount: 300, card: token)
      expect(response.error_message).to be_present
    end
  end
end
