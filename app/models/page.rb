class Page < ActiveRecord::Base
  validates_presence_of :name, :url, :fb_page
  validates_uniqueness_of :fb_page
end