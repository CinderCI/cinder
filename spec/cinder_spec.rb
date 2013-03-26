require "cinder"

describe Cinder do

  describe "VERSION" do
    subject { Cinder::VERSION }
    it { should be_a String }
  end
end
