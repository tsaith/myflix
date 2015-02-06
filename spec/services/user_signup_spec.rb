require 'spec_helper'

describe UserSignup do

  describe "#sign_up" do

    context "with valid personal info and valid card" do
      let(:customer) { double(:customer, successful?: true) }

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end
      after do
        ActionMailer::Base.deliveries.clear
      end

      it "creates the user" do
        alice = Fabricate.build(:user)
        UserSignup.new(alice).sign_up("stripe token", nil)
        expect(User.count).to eq 1
      end

      it "makes the user follows the inviter" do
        alice = Fabricate(:user)
        user = Fabricate.build(:user, email: "tifa@example.com")
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: user.email)
        UserSignup.new(user).sign_up("stripe token", invitation.token)
        tifa = User.where(email: user.email).first
        expect(alice.follows?(tifa)).to be true
      end

      it "makes the inviter follows the user" do
        alice = Fabricate(:user)
        user = Fabricate.build(:user, email: "tifa@example.com")
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: user.email)
        UserSignup.new(user).sign_up("stripe token", invitation.token)
        tifa = User.where(email: user.email).first
        expect(tifa.follows?(alice)).to be true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        user = Fabricate.build(:user, email: "tifa@example.com")
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: user.email)
        UserSignup.new(user).sign_up("stripe token", invitation.token)
        expect(Invitation.first.token).to be nil
      end

      it "sends out email to the user" do
        alice = Fabricate.build(:user)
        UserSignup.new(alice).sign_up("stripe token", nil)
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends out email to the right recipient" do
        alice = Fabricate.build(:user, email: "alice@example.com")
        UserSignup.new(alice).sign_up("stripe token", nil)
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq ["alice@example.com"]
      end

      it "sends out email containing the user's name" do
        alice = Fabricate.build(:user, full_name: "Alice Liddel")
        UserSignup.new(alice).sign_up("stripe token", nil)
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include "Alice Liddel"
      end
    end

    context "with valid personal info and declined card" do
      let(:customer) { double(:customer, successful?: false, error_message: "Your card was declined." ) }
      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
      end
      after { ActionMailer::Base.deliveries.clear }

      it "does not create the user" do
        alice = Fabricate.build(:user, email: "alice@example.com")
        UserSignup.new(alice).sign_up("stripe token", nil)
        expect(User.count).to eq 0
      end

      it "does not send out email" do
        alice = Fabricate.build(:user, email: "alice@example.com")
        UserSignup.new(alice).sign_up("stripe token", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end

    context "with invalid personal info" do
      after { ActionMailer::Base.deliveries.clear }

      it "does not create the user" do
        alice = User.new(email: "alice@example.com")
        UserSignup.new(alice).sign_up("stripe token", nil)
        expect(User.count).to eq 0
      end

      it "does not customer the card" do
        alice = User.new(email: "alice@example.com")
        StripeWrapper::Customer.should_not_receive(:create)
        UserSignup.new(alice).sign_up("stripe token", nil)
        expect(User.count).to eq 0
      end

      it "does not send out email" do
        alice = User.new(email: "alice@example.com")
        UserSignup.new(alice).sign_up("stripe token", nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end
