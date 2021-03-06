require 'rubygems'
require 'mechanize'
require 'rss'
require 'timeout'

class Feed
class << self
			
	def parse url, timeout=5
		Timeout.timeout(timeout) do
			begin
				RSS::Parser.parse( url )
			rescue RSS::InvalidRSSError
				RSS::Parser.parse( url, false )
			end
		end
	end

	def unescape string
		Mechanize::Util::html_unescape( string )
	end

	def clean string
		clean_white_space clean_html( string )
	end

	def clean_html string
		unescape string.gsub(/<.*?>/,'')
	end

	def clean_white_space string
		string.gsub(/\s+/,' ')
	end

end
end

class Feed

	attr_reader :url, :feed, :type, :rss, :atom, 
                    :items, :title, :link, :description,
			:errors

	def initialize url
		@url = url
		@errors = []
		@feed = self.class.parse( @url )
		throw "failed to parse #{@url}" if @feed.nil?
		@type = @feed.respond_to?(:channel) ? :rss : :atom
		@items = @feed.items.map{|item|FeedItem.new(item,@type)}
		if @type == :rss
			@title = self.class.unescape( @feed.channel.title )
			@link = @feed.channel.link
			@description = @feed.channel.description
		else
			@title = @feed.title.content
			@link = @feed.link.href
			@description = @title
		end
	end

end

class FeedItem

	attr_reader :item, :type, :title, :link, :description

	def initialize item, type
		@item = item
		@type = type
		if @type == :rss
			@title = Feed.unescape( @item.title )
			@link = @item.link
			@description = Feed.clean @item.description
		else
			@title = Feed.unescape( @item.title.content )
			@link = @item.link.href
			@description = @item.summary.nil? ?
				@title :
				Feed.clean( @item.summary.content )
		end
	end

end

