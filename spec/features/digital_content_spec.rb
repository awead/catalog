require 'spec_helper'

describe "Digital content", :type => :feature do

  it "shoud include subject headings (BL-374)" do
    visit catalog_path("rrhof:1931")
    within(:css, field_content_selector("subject")) { expect(page).to have_content("Popular music--Awards--United States")  }
  end

  it "should display the video splash screen" do
    visit catalog_path("rrhof:1931")
    expect(page).to have_xpath("//img[@alt='Video splash' and @src = '/assets/video-splash.png']")
  end

end
