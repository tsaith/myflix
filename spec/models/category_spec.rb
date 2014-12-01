require 'spec_helper'
require 'shoulda/matchers'

describe Category do

  it { should have_many :videos }

end
