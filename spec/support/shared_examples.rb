shared_examples "requires sign in" do

  before { clear_current_user }

  it "redirects to the sign in page" do
    action
    expect(response).to redirect_to sign_in_path
  end

  it "sets the flash danger message" do
    action
    expect(flash[:danger]).to be_present
  end

end

shared_examples "tokenable" do
  describe "#generate_token" do
    it "generate a random token" do
      object.generate_token
      expect(object.reload.token).not_to be_nil
    end
  end

  describe "#clear_token" do
    it "clears the user's token" do
      object.generate_token
      object.clear_token
      expect(object.reload.token).to be_nil
    end
  end
end
