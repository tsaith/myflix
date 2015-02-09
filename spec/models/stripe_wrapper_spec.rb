require 'spec_helper'

describe StripeWrapper do

  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => '4242424242424242',
        :exp_month => 1,
        :exp_year => 2016,
        :cvc => "314",
      }
    ).id
  end

  let(:declined_card_token) do
    Stripe::Token.create(
      :card => {
        :number => '4000000000000002',
        :exp_month => 1,
        :exp_year => 2016,
        :cvc => "314",
      }
    ).id
  end

  describe StripeWrapper::Charge do

    context "with valid card" do
      it "charges the card successfully", :vcr do
        response = StripeWrapper::Charge.create(amount: 300, card: valid_token)
        expect(response).to be_successful
      end
    end

    context "with declined card" do
      it "does not charge the card successfully", :vcr do
        response = StripeWrapper::Charge.create(amount: 300, card: declined_card_token)
        expect(response).not_to be_successful
      end
      it "contains an error message", :vcr do
        response = StripeWrapper::Charge.create(amount: 300, card: declined_card_token)
        expect(response.error_message).to be_present
      end
    end
  end

  describe StripeWrapper::Customer do

    it "creates a customer with a valid card", :vcr do
      alice = Fabricate(:user)
      response = StripeWrapper::Customer.create(
        user: alice,
        card: valid_token
      )
      expect(response).to be_successful
    end
    it "returns the customer token with a valid card", :vcr do
      alice = Fabricate(:user)
      response = StripeWrapper::Customer.create(
        user: alice,
        card: valid_token
      )
      expect(response.customer_token).to be_present
    end
    it "does not create a customer with a declined card", :vcr do
      alice = Fabricate(:user)
      response = StripeWrapper::Customer.create(
        user: alice,
        card: declined_card_token
      )
      expect(response).not_to be_successful
    end
    it "returns the error message with a declined card", :vcr do
      alice = Fabricate(:user)
      response = StripeWrapper::Customer.create(
        user: alice,
        card: declined_card_token
      )
      expect(response.error_message).to eq "Your card was declined."
    end
  end
end
