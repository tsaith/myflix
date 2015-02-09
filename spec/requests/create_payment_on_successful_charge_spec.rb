require 'spec_helper'

describe "Create payment on successful charge" do

  let(:event_data) do
    {
      "id"=> "evt_15TTu1DDr8xWpElryt0z8V1Y",
      "created"=> 1423297521,
      "livemode"=> false,
      "type"=> "charge.succeeded",
      "data"=> {
        "object"=> {
          "id"=> "ch_15TTu0DDr8xWpElrj9aO9OL8",
          "object"=> "charge",
          "created"=> 1423297520,
          "livemode"=> false,
          "paid"=> true,
          "amount"=> 999,
          "currency"=> "usd",
          "refunded"=> false,
          "captured"=> true,
          "card"=> {
            "id"=> "card_15TTtzDDr8xWpElrvS0qPUFa",
            "object"=> "card",
            "last4"=> "4242",
            "brand"=> "Visa",
            "funding"=> "credit",
            "exp_month"=> 1,
            "exp_year"=> 2016,
            "fingerprint"=> "25xjiFjdxfdqDNNM",
            "country"=> "US",
            "name"=> nil,
            "address_line1"=> nil,
            "address_line2"=> nil,
            "address_city"=> nil,
            "address_state"=> nil,
            "address_zip"=> nil,
            "address_country"=> nil,
            "cvc_check"=> "pass",
            "address_line1_check"=> nil,
            "address_zip_check"=> nil,
            "dynamic_last4"=> nil,
            "customer"=> "cus_5enVKxWeUBp1yw"
          },
          "balance_transaction"=> "txn_15TTu0DDr8xWpElryfuQYsN0",
          "failure_message"=> nil,
          "failure_code"=> nil,
          "amount_refunded"=> 0,
          "customer"=> "cus_5enVKxWeUBp1yw",
          "invoice"=> "in_15TTu0DDr8xWpElrkTjrbXB7",
          "description"=> nil,
          "dispute"=> nil,
          "metadata"=> {
          },
          "statement_descriptor"=> nil,
          "fraud_details"=> {
          },
          "receipt_email"=> nil,
          "receipt_number"=> nil,
          "shipping"=> nil,
          "refunds"=> {
            "object"=> "list",
            "total_count"=> 0,
            "has_more"=> false,
            "url"=> "/v1/charges/ch_15TTu0DDr8xWpElrj9aO9OL8/refunds",
            "data"=> [

            ]
          }
        }
      },
      "object"=> "event",
      "pending_webhooks"=> 1,
      "request"=> "iar_5enVbdopA7kn6I",
      "api_version"=> "2015-01-11"
    }
  end

  it "creates a payment with the webhook from stripe for charge succeeded" do
    post "/stripe_events", event_data
    expect(Payment.count).to eq 1
  end
  it "creates the payment associated with user" do
    alice = Fabricate(:user, customer_token: "cus_5enVKxWeUBp1yw")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq alice
  end
  it "creates the payment with the amount" do
    post "/stripe_events", event_data
    expect(Payment.first.amount).to eq 999
  end
  it "creates the payment with the reference id" do
    post "/stripe_events", event_data
    expect(Payment.first.reference_id).to eq "ch_15TTu0DDr8xWpElrj9aO9OL8"
  end
end
