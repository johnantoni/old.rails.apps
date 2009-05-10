# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  #def textilize(text)
  #  RedCloth.new(text).to_html
  #end

  def read_news()
    require 'rubygems'
    require 'feed-normalizer'
    require 'open-uri'

    feed = FeedNormalizer::FeedNormalizer.parse open('http://blog.atompad.com/rss')
  	#feed.title # => "International Herald Tribune"
    #@feed.url # => "http://www.iht.com/pages/index.php"
    #@feed.entries.first.url # => "http://www.iht.com/articles/2006/10/03/frontpage/web.1003UN.php"

    feed.class # => FeedNormalizer::Feed
    feed.parser # => SimpleRSS

    feed.title # => "My Feed Your Feed"
    feed.entries.first.content # => "<p>Hello</p>"

    #for entry in feed.entries             
    #entry.content # => "<p>Hello</p>"
    #end
  end
    
end
