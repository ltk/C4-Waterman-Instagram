# app.rb
require 'sinatra'
require 'net/http'
require 'rexml/document'

set :protection, :except => :frame_options

class Photo
	attr_reader :src, :caption, :first

	def initialize(src, caption, count)
		@src, @caption = src, caption
		if count % 3 == 0
			@first = true
		else
			@first = false
		end
	end
end

class XmlPhotoFeed
  # yeah, this probably shouldn't be a class variable...
	@@photos = Array.new

	def initialize(url)
		
		# get the XML data as a string
		xml_data = Net::HTTP.get_response(URI.parse(url)).body

		# extract event information
		doc = REXML::Document.new(xml_data)

		# for some reason lines 37-40 were executing 2-4 times per request... why?
    # I stopped it by checking for objects in the @@photos array
		if @@photos.count == 0
			count = 3
      
      # extract the photo src
			doc.elements.each('rss/channel/item/link') do |ele|
	   			@@photos << Photo.new(ele.text, 'No caption for now.', count)
	   			count+=1
			end
		end
	end

	def photos
		@@photos
	end
end

get "/" do
  feed = XmlPhotoFeed.new('http://instagr.am/tags/c4tmg/feed/recent.rss')
  @title = 'C4 Insasup Shoot Off'
  @photos = feed.photos
  erb :index
end

# This is repetitive... how can I combine this with the above?
post "/" do
  feed = XmlPhotoFeed.new('http://instagr.am/tags/c4tmg/feed/recent.rss')
  @title = 'C4 Insasup Shoot Off'
  @photos = feed.photos
  erb :index
end