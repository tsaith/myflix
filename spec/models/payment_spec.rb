require 'spec_helper'
require 'shoulda/matchers'

describe Payment do
  it { is_expected.to belong_to(:user) }
end
