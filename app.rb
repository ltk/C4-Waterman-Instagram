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
	@@photos = Array.new

	def initialize(url)
		
		# get the XML data as a string
		xml_data = Net::HTTP.get_response(URI.parse(url)).body

		# extract event information
		doc = REXML::Document.new(xml_data)

		# extract the photo src
		if @@photos.count == 0
			count = 3
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

post "/" do
  feed = XmlPhotoFeed.new('http://instagr.am/tags/c4tmg/feed/recent.rss')
  @title = 'C4 Insasup Shoot Off'
  @photos = feed.photos
  erb :index
end

# For Blitz.io testing
get '/mu-038eb2ef-c73eb45b-801e0f12-e3372c7d' do
  '42'
end