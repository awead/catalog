require 'spec_helper'

describe "Error message" do

  it "covers bogus ids" do
    visit catalog_path("foo")
    page.should have_content("Resource id foo was not found or is unavailable")
  end

  it "covers a bogus url (BL-178)" do
    pending "Routing issue"
    visit "asd/asdflkj"
    page.should have_content("Welcome to the Library and Archives Catalog!")
  end

end
