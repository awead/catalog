require 'spec_helper'

describe "Bib. collection facet", :type => :feature do

  it "should display a custom facet for collection name (BL-51)" do
    visit catalog_path("45008581")
    expect(page).to have_content("Archival Collection: Art Collins Papers")
    expect(page).not_to have_content("Art Collins Papers (Rock and Roll Hall of Fame and Museum. Library and Archives)")
    within(:css, "dd.blacklight-collection_ssm a") do
      expect(page).to have_content("Art Collins Papers")
    end
    
  end

end
