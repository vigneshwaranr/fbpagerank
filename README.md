##fbpagerank

A rails web application that tracks a list of facebook pages and sorts them by popularity

**Features:**
* Automatically updates the likes count everyday.
* Only the facebook page id/url is absolutely necessary. The application will figure out other fields from the page if you don't provide other fields in the form.
* You can give the facebook page id in any of the following formats:
 * TomCruise
 * facebook.com/senatus.net
 * http://facebook.com/WillSmith
 * https://www.facebook.com/pages/Garena/25917702541
 * 254669384630
 

**Setup:**

Add the following line to your `crontab` to update the likes count every day.

```
0 0 * * * cd /home/ubuntu/fbpagerank && RAILS_ENV=development bin/rails runner FacebookUtilities.update_likes >> log/cron_log.log 2>&1
```

Replace `/home/ubuntu/fbpagerank` with your path to the application.


**Screenshots:**

![pages_path screenshot](https://raw.github.com/vigneshwaranr/fbpagerank/master/screenshots/pages_path.png "Screenshot that displays the list of pages")

![new_page_path screenshot](https://raw.github.com/vigneshwaranr/fbpagerank/master/screenshots/new_page_path.png "Screenshot that displays the list of pages")
