require 'spec_helper'

describe "EAD display" do

  it "should have biographical notes and administrative histoy (BL-5)" do
    visit catalog_path("ARC-0105")
    click_link "Description"
    page.should have_content("1911 May 18")
    page.should have_content("Born Joseph Vernon Turner, Jr. in Kansas City, Mo.")
    page.should have_content("1939")
    page.should have_content("Releases first single")
    page.should have_content("With Albert Ammons and Meade Lux Lewis, begins a five-year residency at New York's Cafe Society")
    page.should have_content("Big Joe Turner was among the first to mix R&B with boogie-woogie")
    page.should have_content("In the 1960s, after the first wave of rock and roll had died down")
    page.should have_content("Sources")
    page.should have_content("Big Joe Turner Biography")
  end

  it "should have date expressions in the first component level (BL-9)" do
    visit catalog_path("ARC-0105")
    click_link "Contents"
    page.should have_content("Oversize materials, 1977-1985, undated")
  end

  it "should have date expressions in sub component level (BL-9) and accession numbers" do
    visit catalog_path("ARC-0105/ref42")
    page.should have_content("Awards and certificates")
    page.should have_content("Awards and certificates, 1976-1986")
    page.should have_content("Accession Numbers:")
    page.should have_content("A1994.4.10-A1994.4.22")
  end

  it "should have names (BL-7, BL-147)" do
    visit catalog_path("ARC-0058")
    click_link "Find More"
    page.should have_content("Alternative rock music")
  end

  it "should have a dimensions note (BL-124)" do
    pending "May need to add additional display field for ChromaDepth"
    visit catalog_path("ARC-0065/ref10")
    page.should have_content("Limited Print Run")
    page.should have_content("Non-numbered edition of 200")
    page.should have_content("Dimensions:")
    page.should have_content("ChromaDepth 3D image with required glass for viewing")
    page.should have_content("23")
    page.should have_content("29")
    page.should have_content("Location:")
    page.should have_content("Drawer-Folder: FF.1.4-7, Object: 1")
  end

  it "should display a component and its immediate parent" do
    visit catalog_path("ARC-0065/ref62")
    page.should have_content("Series I: Flyers, 1980, 1989-1992")
    page.should have_content("Ultras with Dick Dale, 1992 August 1")
  end

  it "should show accession numbers (BL-118)" do
    visit catalog_path("ARC-0058/ref62")
    page.should have_content("A2005.31.15")
  end

  it "should display italics (BL-33)" do
    visit catalog_path("ARC-0058")
    page.should have_xpath('//em', :text => 'New Musical Express', :visible => true)
    page.should have_xpath('//em', :text => 'Esquire', :visible => true)
  end

  it "should show separated materials notes (BL-43)" do
    visit catalog_path("ARC-0105")
    click_link "Description"
    page.should have_content("Separated Materials")
    page.should have_content("Biographical Note")
  end

  it "should show accruals under Colection History (BL-418)" do
    visit catalog_path("ARC-0006")
    click_link "Collection History"
    page.should have_content("Accruals to the collection are located in Series VII.")
  end

  it "should show separated materials within Collection History (BL-418)" do
    visit catalog_path("ARC-0003")
    click_link "Collection History"
    page.should have_content("Some print and audiovisual materials have been transferred to the library collection.")
  end

  it "should show access restrictions within Access and Use" do
    visit catalog_path("ARC-0003")
    click_link "Access and Use"
    page.should have_content("Collection is open for research")
  end

  it "should show existence and Location of Originals (BL-117)" do
    visit catalog_path("ARC-0006/ref641")
    page.should have_content("original plaque")
  end

  it "should show physical description (BL-119)" do
    visit catalog_path("ARC-0006/ref725")
    page.should have_content("Trimmed")
  end

  it "should show language of Materials, Museum Acc. #, Separated Materials (BL-118)" do
    visit catalog_path("ARC-0006/ref690")
    page.should have_content("Language: French")
    page.should have_content("A2010.1.18")
    page.should have_content("Item on exhibit. Consult the Library and Archives staff in advance of your visit for additional information.")
  end

  it "should show custodial history (BL-120, BL-130)" do
    visit catalog_path("ARC-0037")
    click_link "Description"
    page.should have_content("Custodial History")
    page.should have_content("The Jeff Gold Collection was received by the Rock and Roll Hall of Fame Museum")
  end

  it "should show dates (BL-164) and accruals notes (BL-155)" do
    visit catalog_path("ARC-0037")
    within(:css, "span.unitdate") do
      page.should have_content("Inclusive, 1938-2010, undated")
    end
    click_link "Description"
    page.should have_content("Accruals")
  end

  it "should displaying multiple copies of an archival item (BL-202)" do
    visit catalog_path("ARC-0006/ref216")
    within(:css, field_content_selector("location")) do
      page.should have_content("Box: 5, Folder: 1, Object: 4")
      page.should have_content("Box: 1B, Folder: 22, Object: 4")
    end
    within(:css, field_content_selector("material")) do
      page.should have_content("Original Copy")
      page.should have_content("Access Copy")
    end
  end

  it "should show processing information note (BL-196)" do
    visit catalog_path("ARC-0003")
    page.should have_content("Processing Information")
    page.should have_content("Processed by Christine Borne, Project Archivist. Completed on June 1, 2010.")
  end

  it "should have AT genre facet display (BL-195)" do
    visit catalog_path("ARC-0005")
    click_link "Find More"
    page.should have_content("Clippings (Books, newspapers, etc.)")
    page.should have_content("Photographs")
  end

  it "should show Additional chronologies (BL-194)" do
    visit catalog_path("ARC-0005")
    click_link "Description"
    page.should have_content("First meeting of the Organization")
    page.should have_content("Incorporated as a Minnesota non-profit organization")
    page.should have_content("Holds first annual Eddie Cochran Weekend in Alberta Lea, Minn")
  end

  it "should show title nodes in ead (BL-209)" do
    pending "AT not exporting XML correctly"
    visit catalog_path("ARC-0026")
    click_link "Description"
    page.should have_xpath('//em', :text => 'Normal As The Next Guy', :visible => true)
  end

  it "should show items in the sidebar" do
    visit catalog_path("ARC-0037")
    within(:css, ".nav-stacked") do
      page.should have_content("Summary")
      page.should have_content("Description")
      page.should have_content("Collection History")
      page.should have_content("Access and Use")
      page.should have_content("Find More")
      page.should have_content("Contents")
      page.should have_content("Search Collection")
    end
  end

  it "should show name Headings listed as 'Creator' (BL-294)" do
    visit catalog_path("ARC-0258")
    click_link "Find More"
    page.should have_content("Diltz, Henry")
  end

  it "should include corpname and persname in the headings (BL-335)" do
    visit catalog_path("ARC-0058")
    click_link "Find More"
    page.should have_content("Morrison, Jim, 1943-1971")
    page.should have_content("Denali (Musical group)")
  end

  it "should display bibliographies from finding aids (BL-325)" do
    visit catalog_path("ARC-0161")
    click_link "Description"
    page.should have_content("Bibliography")
    page.should have_content("All Music Guide. Accessed February 4, 2013. http://www.allmusic.com/.")
    page.should have_content("Doo-Wop: Biography, Groups and Discography. Accessed February 4, 2013. http://doo-wop.blogg.org/.")
  end

  it "should display summary information" do
    visit catalog_path("ARC-0003")
    page.should have_content("Summary")
    within(:css, "dl#geninfo") do
      page.should have_content("Dates:")
      page.should have_content("Size:")
      page.should have_content("Collection Number:")
      page.should have_content("Language(s):")
      page.should have_content("Abstract:")
      page.should have_content("Finding Aid Permalink:")
    end
    page.should_not have_content("Colletion Overview")
  end

  it "should display field in Description tab" do
    visit catalog_path("ARC-0064")
    click_link "Description"
    page.should have_content("Administrative History")
    visit catalog_path("ARC-0161")
    click_link "Description"
    page.should have_content("Biographical Note")
    page.should have_content("Bibliography")
    visit catalog_path("ARC-0001")
    click_link "Description"
    page.should have_content("Scope and Contents note")
  end

  it "should display fields in the Collection History tab" do
    visit catalog_path("ARC-0006")
    click_link "Collection History"
    page.should have_content("Custodial History")
    page.should have_content("Accruals")
    page.should have_content("Separated Materials")
  end

  it "should display fields in the Access and Use tab" do
    visit catalog_path("ARC-0080")
    click_link "Access and Use"
    page.should have_content("Access Restrictions")
    page.should have_content("Use Restrictions")
  end

  it "should display headings" do
    visit catalog_path("ARC-0003")
    click_link "Find More"
    page.should have_content("Names:")
    page.should have_content("Subjects:")
    page.should have_content("Formats:")
  end

  it "should have a tab for searchign within the collection" do
    visit catalog_path("ARC-0003")
    click_link "Search Collection"
    page.should have_content("Search Collection")
  end

  it "should display a label for digital content" do
    visit catalog_path("RG-0010/ref42")
    page.should have_content("Online")
  end

  it "should display the full finding aid" do
    visit catalog_path("ARC-0037", {:full => true})
    page.should have_content("Color pinup")
  end

  it "should toggle the display between full and default finding aid views" do
    visit catalog_path("ARC-0037")
    within(:css, "#record_controls") do
      page.should have_content("Full")
    end
    visit catalog_path("ARC-0037", {:full => true})
    within(:css, "#record_controls") do
      page.should have_content("Default")
    end
  end

  it "should display the list view of components' archival material type in parenthesis" do
    visit catalog_path("ARC-0037/ref2214")
    page.should have_content("(Moving Images)")
  end

end
