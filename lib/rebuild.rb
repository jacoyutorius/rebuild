require "rebuild/version"
require "rebuild/crawl"
require "rebuild/db"
require "thor"
require "open-uri"
require "rbconfig"

module Rebuild
  # Your code goes here...
  include DB

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

      DB::Episode.exist? episode

      Dir::mkdir("./mp3") unless File.exists? "./mp3"

      episode = episode.to_s
      episode += "a" if options[:aftershow]

      # filename = File.expand_path(__FILE__, "./mp3/podcast-ep#{episode}.mp3")
      filename = "./mp3/podcast-ep#{episode}.mp3"
      puts filename

      unless File.exists? filename
        url = "http://cache.rebuild.fm/podcast-ep#{episode}.mp3"
        open(filename, "wb") do |out|
          open(url) do |data| 
            out.write(data.read)
          end
        end
      end
  		
      
  		puts "play show #{filename}" 

      os = RbConfig::CONFIG["host_os"]
      case os
      when /darwin/
        `afplay #{filename} -d`
      else
        puts "Your PC cant't play mp3 from this gem! Please open #{filename} directry."
      end
  	end

    desc "clearmp3", "clear downloaded mp3"
    def clearmp3
      `rm -rf mp3`
    end

  	desc "shownotes","show shownotes"
  	option :aftershow, :type => :boolean
  	def shownotes episode

      DB::Episode.exist? episode

      DB::Episode.find_by_no(episode).shownotes.each do |note|
        puts note.url
      end

  	end

  end
end
