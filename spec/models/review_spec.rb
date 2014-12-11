require 'spec_helper'
require 'shoulda/matchers'

describe Review do

  it { is_expected.to belong_to :user }
  it { is_expected.to belong_to :video }
  it { is_expected.to validate_presence_of :user }
  it { is_expected.to validate_presence_of :video }
  it { is_expected.to validate_presence_of :rating }
  it { is_expected.to validate_presence_of :content }

end
