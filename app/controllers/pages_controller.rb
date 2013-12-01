include FacebookUtilities
class PagesController < ApplicationController
  def index
    @pages = Page.order("likes DESC").limit(30)
  end

  def create
    param = params[:page]
    fb_page_id = param[:fb_page]

    if fb_page_id.nil? || fb_page_id.strip == ''
      redirect_to new_page_path, :alert => 'FB Page must not be empty!'
      return
    end

    fb_data = FacebookUtilities.get_fb_details fb_page_id.strip
    if fb_data.has_key? 'error'
      if fb_data.has_key? 'ownerror'
        redirect_to new_page_path, :alert => fb_data['error'].html_safe
      else
        redirect_to new_page_path, :alert => "The facebook page <i>#{fb_page_id}</i> does not exist!".html_safe
        end
      return
    end

    page = FacebookUtilities.get_page_from param, fb_data

    if page.save
      redirect_to pages_path, :notice => "Page added successfully!"
    else
      error = page.errors.full_messages.map{|m| "* " + m.strip}.join('<br />').html_safe
      redirect_to new_page_path, :alert => error
    end
  end

end