require "spec_helper"


describe Rockhall::CollectionInventory do

  before :each do
    @inventory = Rockhall::CollectionInventory.new("ARC-0005")
  end

  describe "::initialize" do
    it "should have accessors" do
      @inventory.id.should == "ARC-0005"
    end
  end


end