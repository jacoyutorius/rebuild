require "rebuild/version"
require "rebuild/crawl"

require "thor"

module Rebuild
  # Your code goes here...

  class FM < Thor
  	
  	desc "update", "get new show"
  	def update
  		Rebuild::Crawl.update
  	end

  	desc "episodes", "list of shows"
  	def episodes
  		(1..54).each do |i|
	  		puts i
	  	end
  	end

  	desc "listen","listen episode"
  	option :aftershow, :type => :boolean
  	def listen episode

  		episode = episode.to_s
  		episode += "a" if options[:aftershow]
  		# file = File.expand_path(__FILE__, "../mp3/podcast-ep#{episode}.mp3")
  		# file = "./mp3/podcast-ep56.mp3"
  		file = "./mp3/podcast-ep#{episode}.mp3"
  		puts "play aftershow #{file}" 
  		`afplay #{file} -d`
  	end

  	desc "shownotes","show shownotes"
  	option :aftershow, :type => :boolean
  	def shownotes episode
  		if options[:aftershow]
  			%w(RubyKaigi2014 会場ネットワークの裏側 CONBU).each{|v| puts v}
  		else
  			%w(github.com/amatsuda Asakusa.rb Seattle.rb クックパッドにおける最近のActiveRecord運用事情).each{|v| puts v}
  		end
  	end
  end

end
