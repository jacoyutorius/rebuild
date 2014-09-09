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
      DB::Episode.list
  	end

  	desc "listen","listen episode"
  	option :aftershow, :type => :boolean
  	def listen episode

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
  		
  		puts "play aftershow #{filename}" 

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

      episode = DB::ShowNote.find_by_episode episode
      episode.shownotes.each do |note|
        puts note
      end


  		if options[:aftershow]
  			%w(RubyKaigi2014 会場ネットワークの裏側 CONBU).each{|v| puts v}
  		else
  			%w(github.com/amatsuda Asakusa.rb Seattle.rb クックパッドにおける最近のActiveRecord運用事情).each{|v| puts v}
  		end

  	end


    def os
      @os ||= (
        host_os = RbConfig::CONFIG['host_os']
        case host_os
        when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
          :windows
        when /darwin|mac os/
          :macosx
        when /linux/
          :linux
        when /solaris|bsd/
          :unix
        else
          raise Error::WebDriverError, "unknown os: #{host_os.inspect}"
        end
      )
    end

  end

end
