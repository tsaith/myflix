require 'spec_helper'

describe "Deactivate user on failed charge" do

  let(:event_data) do
    {
      "id" => "evt_15UEKXDDr8xWpElrh7gf4rSF",
      "created" => 1423475989,
      "livemode" => false,
      "type" => "charge.failed",
      "data" => {
        "object" => {
          "id" => "ch_15UEKXDDr8xWpElronXSW8Q8",
          "object" => "charge",
          "created" => 1423475989,
          "livemode" => false,
          "paid" => false,
          "amount" => 999,
          "currency" => "usd",
          "refunded" => false,
          "captured" => false,
          "card" => {
            "id" => "card_15UEIYDDr8xWpElrJYWoroE9",
            "object" => "card",
            "last4" => "0341",
            "brand" => "Visa",
            "funding" => "credit",
            "exp_month" => 2,
            "exp_year" => 2018,
            "fingerprint" => "mYbhsdHxWu2MozuP",
            "country" => "US",
            "name" => nil,
            "address_line1" => nil,
            "address_line2" => nil,
            "address_city" => nil,
            "address_state" => nil,
            "address_zip" => nil,
            "address_country" => nil,
            "cvc_check" => "pass",
            "address_line1_check" => nil,
            "address_zip_check" => nil,
            "dynamic_last4" => nil,
            "customer" => "cus_5fZN1jMLn1LBLC"
          },
          "balance_transaction" => nil,
          "failure_message" => "Your card was declined.",
          "failure_code" => "card_declined",
          "amount_refunded" => 0,
          "customer" => "cus_5fZN1jMLn1LBLC",
          "invoice" => nil,
          "description" => "Failed payment",
          "dispute" => nil,
          "metadata" => {},
          "statement_descriptor" => nil,
          "fraud_details" => {},
          "receipt_email" => nil,
          "receipt_number" => nil,
          "shipping" => nil,
          "refunds" => {
            "object" => "list",
            "total_count" => 0,
            "has_more" => false,
            "url" => "/v1/charges/ch_15UEKXDDr8xWpElronXSW8Q8/refunds",
            "data" => []
          }
        }
      },
      "object" => "event",
      "pending_webhooks" => 1,
      "request" => "iar_5fZTxJIg8hnb0q",
      "api_version" => "2015-01-11"
    }
  end

  it "deactivates a user with the web hook from stripe for charge failed" do
    alice = Fabricate(:user, customer_token: "cus_5fZN1jMLn1LBLC")
    post "/stripe_events", event_data
    expect(alice.reload).not_to be_active
  end
end
