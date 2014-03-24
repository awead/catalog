require 'spec_helper'

describe "Bib. collection facet" do

  it "should display a custom facet for collection name (BL-51)" do
    visit catalog_path("45008581")
    page.should have_content("Archival Collection: Art Collins Papers")
    page.should_not have_content("Art Collins Papers (Rock and Roll Hall of Fame and Museum. Library and Archives)")
    within(:css, "dd.blacklight-collection_ssm a") do
      page.should have_content("Art Collins Papers")
    end
    
  end

end
