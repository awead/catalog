Then /^I should see a facet for "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should have_xpath('//h3', :text => regexp)
  else
    assert page.has_xpath?('//h3', :text => regexp)
  end

end

Then /^I should not see a facet for "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should_not have_xpath('//h3', :text => regexp)
  else
    assert !page.has_xpath?('//h3', :text => regexp)
  end

end

Then /^I should see the facet term "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should have_xpath("//*/a[contains(@class, 'facet_select')]", :text => regexp)
  else
    assert page.has_xpath?("//*/a[contains(@class, 'facet_select')]", :text => regexp)
  end

end

Then /^I should see a link to "([^"]*)"$/ do |arg1|
  response.should have_selector("a", :href=>path_to(arg1))
end

Then /^I should not see a link to "([^\"]*)"$/ do |arg1|
  response.should_not have_selector("a", :href=>path_to(arg1))
end

Then /^I should be able to follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^I should see the field title "([^"]*)" contain "([^"]*)"$/ do |arg1, arg2|
  page.should have_xpath("//*/dt[contains(@class, arg1)]", :text => arg2)
end

Then /^I should see the field content "([^"]*)" contain "([^"]*)"$/ do |arg1, arg2|
  page.should have_xpath("//*/dd[contains(@class, arg1)]", :text => arg2)
end

Then /^I should see the field content "(.*?)" match "(.*?)"$/ do |arg1, arg2|
  find(("dd." + arg1)).text.should match arg2
end

Then /^I should see the field content "([^"]*)" not contain "([^"]*)"$/ do |arg1, arg2|
  page.should_not have_xpath("//*/dd[contains(@class, arg1)]", :text => arg2)
end

Then /^I should see "([^"]*)" in "([^"]*)"$/ do |arg1, arg2|
  page.should have_xpath("//*/span[contains(@class, arg2)]", :text => arg1)
end

Then /^I should see the word "([^"]*)" highlighted$/ do |arg1|
  page.should have_xpath("//*/span[contains(@style, 'background-color:yellow')]", :text => arg1)
end

Then /^I should see an image for "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should have_xpath("//*/img[contains(@src, arg1)]")
  else
    assert page.has_xpath?("//*/img[contains(@src, arg1)]")
  end
end

Given /^the opac is down$/ do
  Rails.configuration.rockhall_config[:opac_ip] = "1.2.3.4"
end

When /^I wait for "(.*?)" seconds$/ do |arg1|
  sleep(arg1.to_i)
end

When /^I follow the "(.*?)" link "(.*?)"$/ do |arg1, arg2|
  find(("dd." + arg1 + " a")).click
end

Then /^I should be able to follow the "(.*?)" link "(.*?)"$/ do |arg1, arg2|
  find(("dd." + arg1 + " a")).click
end

When /^I follow the facet link "(.*?)"$/ do |arg1|
  all('a.facet_select').select {|elt| elt.text == arg1 }.first.click
end

Then /^all bookmarks should be checked$/ do
  all('form.bookmark_toggle label.toggle_bookmark').each do |box|
    box.text.should == "In Bookmarks"
  end
end

Then /^all bookmarks should be unchecked$/ do
  all('form.bookmark_toggle label.toggle_bookmark').each do |box|
    box.text.should == "Bookmark"
  end
end




