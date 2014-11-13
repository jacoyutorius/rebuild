require "rss"
require "pp"
require "rebuild/db"
require "nokogiri"

module Rebuild
	module Reader
		def self.read
			
			DB.init	unless File.exists?("./anemone.db")

			url = "http://feeds.rebuild.fm/rebuildfm"
			rss = RSS::Parser.parse(url)
			rss.channel.items.each do |feed|
				episode = Rebuild::DB::Episode.create!(
					no: feed.link.split("/")[-1],
					title: feed.title,
					description: feed.itunes_summary
				)

				doc = Nokogiri::HTML.parse feed.description
				doc.xpath("//li").each do |note|

					if note.children.first.attributes.length > 0
	
						Rebuild::DB::ShowNote.create!(
							episode_id: episode.id,
							note: note.children.first.children.first.text,
							url: note.children.first.attributes.first[1].value
							)
					end
				end

			end

		end
	end
end