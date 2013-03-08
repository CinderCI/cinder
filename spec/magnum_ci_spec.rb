require "magnum_ci"

describe MagnumCI do

  describe "VERSION" do
    subject { MagnumCI::VERSION }
    it { should be_a String }
  end
end
