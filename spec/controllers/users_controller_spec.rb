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

  describe "POST create" do

    context "with valid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user)
      end
      after { ActionMailer::Base.deliveries.clear }

      it "creates the user" do
        expect(User.count).to eq 1
      end
      it "redirects to the home page" do
        expect(response).to redirect_to home_path
      end
    end

    context "with invalid input" do
      before do
        post :create, user: Fabricate.attributes_for(:user, password: "")
      end
      after { ActionMailer::Base.deliveries.clear }

      it "does not create the user" do
        expect(User.count).to eq 0
      end
      it "renders the :new template" do
        expect(response).to render_template :new

      end
      it "sets @user" do
        expect(assigns(:user)).to be_instance_of User
      end
    end

    context "sending emails" do

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
