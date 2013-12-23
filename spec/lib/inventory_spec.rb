require "spec_helper"

describe Rockhall::Ead::Inventory do

  before :each do
    @inventory = Rockhall::Ead::Inventory.new("ARC-0005")
  end

  describe "::initialize" do
    it "should have accessors" do
      @inventory.id.should == "ARC-0005"
    end
  end

end
