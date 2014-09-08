require "rebuild/version"
require "rebuild/crawl"
require "rebuild/db"

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
      DB::Episode.order(:no).each do |epi|
        puts epi.title
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

      DB::Episode.find_by_no(episode).shownotes.each do |note|
        puts note.url
      end

  	end
  end

end
