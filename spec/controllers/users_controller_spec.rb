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

    context "successful user sign up" do
      let(:result) { double(:sign_up_result, successful?: true ) }

      before do
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
      end

      it "sets flash success message" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "123"
        expect(flash[:success]).to be_present
      end

      it "redirects to the home page" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "123"
        expect(response).to redirect_to home_path
      end

    end

    context "failed user sign up" do
      let(:result) do
        double(:sign_up_result, successful?: false, error_message: "This is an error message." )
      end

      before do
        UserSignup.any_instance.should_receive(:sign_up).and_return(result)
      end

      it "sets @user" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "123"
        expect(assigns(:user)).to be_instance_of User
      end

      it "renders the :new template" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "123"
        expect(response).to render_template :new
      end

      it "sets the flash danger message" do
        post :create, user: Fabricate.attributes_for(:user), stripeToken: "123"
        expect(flash[:danger]).to be_present
      end
    end
  end
end
