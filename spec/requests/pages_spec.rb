require 'spec_helper'

describe "Pages" do
  describe "GET /pages" do
    it "displays the list of fb pages" do
      @page = Page.create({
                              :name => 'Will Smith',
                              :url => 'http://facebook.com/WillSmith',
                              :fb_page => 'WillSmith',
                              :likes => 54735808,
                              :category => 'Actor/director',
                              :description => 'Cool guy'
                          })
      visit pages_path
      page.should have_content 'Will Smith'
    end

    it "should open the add page when Add New Page is clicked" do
      visit pages_path
      click_link_or_button 'Add New Page'
      current_path.should == new_page_path
    end

    it "should not let you add a page with empty parameters" do
      visit pages_path
      click_link_or_button 'Add New Page'
      current_path.should == new_page_path
      click_link_or_button 'Add Page'
      current_path.should == new_page_path
      page.should have_content "FB Page must not be empty!"
    end

    it "should let you cancel adding a page" do
      visit pages_path
      click_link_or_button 'Add New Page'
      current_path.should == new_page_path
      click_link_or_button 'Cancel'
      current_path.should == pages_path
    end

    it 'should not allow duplicate pages' do
      2.times {
        visit new_page_path
        fill_in 'Fb page', :with => 'TomHanks'
        click_link_or_button 'Add Page'
      }
      current_path.should == new_page_path
      page.should have_content "Fb page has already been taken"
    end

    it "should allow adding page id in different formats"  do
      for page_id in ['senatus.net', 'facebook.com/TomCruise', 'http://facebook.com/WillSmith',
                      'https://www.facebook.com/pages/Garena/25917702541', '254669384630']
        visit new_page_path
        fill_in 'Fb page', :with => page_id
        click_link_or_button 'Add Page'
        assert current_path == pages_path, "Failing format #{page_id}"
        page.should have_content "Page added successfully!"
        #save_and_open_page
      end
    end

    it 'should not allow duplicate pages even if the user gives the page id in different formats'  do
      for page_id in ['NeembuuUploader', 'facebook.com/NeembuuUploader']
        visit new_page_path
        fill_in 'Fb page', :with => page_id
        click_link_or_button 'Add Page'
      end
      current_path.should == new_page_path
      page.should have_content "Fb page has already been taken"
    end

    it 'should not allow invalid fb_page id' do
      visit new_page_path
      fill_in 'Fb page', :with => 'google.com/amazon'
      click_link_or_button 'Add Page'
      current_path.should == new_page_path
      page.should have_content "Invalid Page ID format!"
    end

    it 'should display error if the page does not exist' do
      visit new_page_path
      fill_in 'Fb page', :with => 'blah'
      click_link_or_button 'Add Page'
      current_path.should == new_page_path
      page.should have_content "does not exist!"
    end
  end
end
