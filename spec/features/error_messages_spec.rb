require 'spec_helper'

describe "Error message" do

  it "covers bogus ids" do
    visit catalog_path("foo")
    page.should have_content("Sorry, you have requested a record that doesn't exist.")
  end

end
