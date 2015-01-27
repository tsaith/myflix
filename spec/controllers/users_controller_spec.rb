require "spec_helper"

describe UsersController do

  describe "GET show" do

    it_behaves_like "requires sign in" do
      let(:action) { get :show, id: 1 }
    end

    it "sets @user" do
      set_current_user
      alice = Fabricate(:user)
      get :show, id: alice.slug
      expect(assigns(:user)).to eq alice
    end
  end

  describe "GET new" do
    it "sets @user" do
      get :new
      expect(assigns(:user)).to be_instance_of User
    end
  end

  describe "GET new_with_invitation_token" do
    it "renders the :new template" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(response).to render_template :new
    end
    it "sets @user with recipient's email" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:user).email).to eq invitation.recipient_email
    end
    it "sets @invitation_token" do
      invitation = Fabricate(:invitation)
      get :new_with_invitation_token, token: invitation.token
      expect(assigns(:invitation_token)).to eq invitation.token
    end
    it "redirects to the expired token page for invalid token" do
      get :new_with_invitation_token, token: "invalid token"
      expect(response).to redirect_to expired_token_path
    end
  end

  describe "POST create" do

    context "with valid input" do
      before { StripeWrapper::Charge.stub(:create) }
      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq 1
      end

      it "sets flash success message" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(flash[:success]).to be_present
      end

      it "redirects to the home page" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(response).to redirect_to home_path
      end

      it "makes the user follows the inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "tifa@example.com")
        post :create, user: { email: "tifa@example.com", password: "password", full_name: "Tifa Lockhart"}, invitation_token: invitation.token
        tifa = User.last
        expect(alice.follows?(tifa)).to be true
      end

      it "makes the inviter follows the user" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "tifa@example.com")
        post :create, user: { email: "tifa@example.com", password: "password", full_name: "Tifa Lockhart"}, invitation_token: invitation.token
        tifa = User.last
        expect(tifa.follows?(alice)).to be true
      end

      it "expires the invitation upon acceptance" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice, recipient_email: "tifa@example.com")
        post :create, user: { email: "tifa@example.com", password: "password", full_name: "Tifa Lockhart"}, invitation_token: invitation.token
        expect(Invitation.first.token).to be nil
      end

    end

    context "with invalid input" do
      before { StripeWrapper::Charge.stub(:create) }
      after { ActionMailer::Base.deliveries.clear }

      it "does not create the user" do
        post :create, user: Fabricate.attributes_for(:user, password: "")
        expect(User.count).to eq 0
      end
      it "renders the :new template" do
        post :create, user: Fabricate.attributes_for(:user, password: "")
        expect(response).to render_template :new

      end
      it "sets @user" do
        post :create, user: Fabricate.attributes_for(:user, password: "")
        expect(assigns(:user)).to be_instance_of User
      end
      it "sets the flash danger message" do
        post :create, user: Fabricate.attributes_for(:user, password: "")
        expect(flash[:danger]).to be_present
      end
    end

    context "sending emails" do

      before { StripeWrapper::Charge.stub(:create) }
      after { ActionMailer::Base.deliveries.clear }

      it "sends out email to the user with valid inputs" do
        post :create, user: { email: "alice@example.com", password: "password", full_name: "Alice Liddel" }
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end
      it "sends out email to the right recipient" do
        post :create, user: { email: "alice@example.com", password: "password", full_name: "Alice Liddel" }
        message = ActionMailer::Base.deliveries.last
        expect(message.to).to eq ["alice@example.com"]
      end
      it "sends out email containing the user's name with valid inputs" do
        post :create, user: { email: "alice@example.com", password: "password", full_name: "Alice Liddel" }
        message = ActionMailer::Base.deliveries.last
        expect(message.body).to include "Alice Liddel"
      end
      it "does not send out email with invalid inputs" do
        post :create, user: { email: "alice@example.com" }
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

end
