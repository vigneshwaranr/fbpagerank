require 'net/http'
module FacebookUtilities
  def self.get_fb_details(fb_page_id)
    # http://www.facebook.com/WillSmith -> WillSmith
    # WillSmith -> WillSmith
    # google.com/WillSmith -> nil
    match = fb_page_id.match(/^(?:.*?facebook\.com\/)?(?<id>[\w\.]+?)$/)
    match = fb_page_id.match(/facebook.com\/pages\/[^\/]*\/(?<id>[\d]+)/) if match.nil?
    if match.nil? || match[:id].strip == ''
      # Intentionally not using :error to be compatible with fb response
      return {
          'ownerror' => true,
          'error' => 'Invalid Page ID format!<br />
                      Please enter in the form <i>http://www.facebook.com/WillSmith</i> or just <i>WillSmith</i>'
      }
    end
    url = URI.parse('http://graph.facebook.com/' + match[:id])
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) { |http|
      http.request(req)
    }
    JSON.parse(res.body)
  end

  def self.get_page_from(param, fb_data)
    def get(param)
      if param.nil? || param.strip == ''
        nil
      else
        param
      end
    end
    def valid?(uri)
      !!URI.parse(uri)
    rescue URI::InvalidURIError
      false
    end
    page = Page.new
    page.name = get(param[:name]) || fb_data['name']
    page.fb_page = fb_data['username'] || fb_data['id']
    page.url = get(param[:url]) || fb_data['website']
    page.url = fb_data['link'] if not valid? page.url
    page.description = get(param[:description]) || fb_data['description'] || fb_data['company_overview'] || fb_data['about'] || fb_data['name']
    page.likes = fb_data['likes']
    page.category = fb_data['category']
    page
  end

  def self.update_likes
    puts "[#{Time.now.inspect}] Starting update.."
    Page.all.each do |page|
      fb_data = get_fb_details page[:fb_page]
      if fb_data.has_key? 'likes'
        page.update_attribute(:likes, fb_data['likes'])
        puts "Updated #{page[:name]} to #{fb_data['likes']} likes.."
      end
    end
    puts "Updated #{Page.count} records."
  end
end