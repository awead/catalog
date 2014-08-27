require 'spec_helper'

describe "Bib. citations", :type => :feature do

  it "should display authors for 1XX fields" do
    visit citation_catalog_path({:id => "8168726"})
    expect(page).to have_content("Palmer, Robert. Deep Blues. Harmondsworth, Middlesex, England: Penguin Books, 1982.")
    expect(page).to have_content("Palmer, R. (1982). Deep blues. Harmondsworth, Middlesex, England: Penguin Books.")
    expect(page).not_to have_content("Palmer, Robert, Manny Gerard, and Jane Scott.")
  end

end
