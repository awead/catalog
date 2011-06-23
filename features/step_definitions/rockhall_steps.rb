Then /^I should see a facet for "([^"]*)"$/ do |arg1|
  regexp = Regexp.new(arg1)

  if page.respond_to? :should
    page.should have_xpath('//h3', :text => regexp)
  else
    assert page.has_xpath?('//h3', :text => regexp)
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

