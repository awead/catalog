require 'spec_helper'

describe "Bib. citations" do

  it "should display authors for 1XX fields" do
    visit citation_catalog_path({:id => "8168726"})
    page.should have_content("Palmer, Robert. Deep Blues. Harmondsworth, Middlesex, England: Penguin Books, 1982.")
    page.should have_content("Palmer, R. (1982). Deep blues. Harmondsworth, Middlesex, England: Penguin Books.")
    page.should_not have_content("Palmer, Robert, Manny Gerard, and Jane Scott.")
  end

end
