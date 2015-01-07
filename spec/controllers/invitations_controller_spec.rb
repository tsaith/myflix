require "spec_helper"

describe InvitationsController do

  describe "GET new" do

    it_behaves_like "requires sign in" do
      let(:action) { get :new }
    end

    it "set @invitation to a new invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_new_record
      expect(assigns(:invitation)).to be_instance_of Invitation
    end
  end

  describe "POST create" do

    it_behaves_like "requires sign in" do
      let(:action) { get :create }
    end

    context "with valid inputs" do

      before do
        set_current_user
        post :create, invitation: Fabricate.attributes_for(:invitation, recipient_email: "alice@example.com")
      end
      after {  ActionMailer::Base.deliveries.clear }

      it "shows flash success messages" do
        expect(flash[:success]).to be_present
      end

      it "creates an invitation" do
        expect(current_user.invitations.count).to eq 1
      end

      it "sends an email to the recipient" do
        expect(ActionMailer::Base.deliveries.last.to).to eq ["alice@example.com"]
      end
      it "redirects to the invitaion new page" do
        expect(response).to redirect_to new_invitation_path
      end

    end

    context "with invalid inputs" do

      before do
        set_current_user
        post :create, invitation: { recipient_name: "alice" }
      end

      it "renders the :new template" do
        expect(response).to render_template :new
      end
      it "sets @invitation to a new invitation" do
        expect(assigns(:invitation)).to be_new_record
        expect(assigns(:invitation)).to be_instance_of Invitation
      end
      it "shows flash error messages" do
        expect(flash[:error]).to be_present
      end

      it "does not create an invitation" do
        post :create, invitation: { recipient_name: "alice" }
        expect(current_user.invitations.count).to eq 0
      end
    end

  end

end
