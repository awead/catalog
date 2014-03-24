require 'spec_helper'

describe "Error message" do

  it "covers bogus ids" do
    visit catalog_path("foo")
    page.should have_content("The page you were looking for doesn't exist. You may have mistyped the address or the page may have moved.")
  end

end
