shared_examples "requires sign in" do

  before { clear_current_user }

  it "redirects to the sign in page" do
    action
    expect(response).to redirect_to sign_in_path
  end

  it "sets the flash error message" do
    action
    expect(flash[:error]).to be_present
  end

end
