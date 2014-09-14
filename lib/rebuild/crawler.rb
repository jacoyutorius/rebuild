$LOAD_PATH << __dir__
require "anemone"
require "sqlite3"
require "pp"
require "db"

module Rebuild

	module Crawler

		include DB


		def self.fetch
			# puts "updated show list!"

			# url = "http://rebuild.fm/"
			url = "http://rebuild.fm/56"

			option = {
				storage: Anemone::Storage.SQLite3,
				database: "/Users/yuto-ogi/Work/ruby/rebuild/lib/anemone.db"
			}

			puts url
			puts option

			pp DB::Episode.nil?


			Anemone.crawl(url) do |anemone|

				anemone.focus_crawl do |page|
					puts page
					page.links.keep_if do |link|
						puts link.to_s.match(/http:\/\/rebuild.fm\/[0-9]+|[a]/)
					end
				end

				anemone.on_every_page do |page|

					desc = ""
					css_path_to_desc = "#contents > div > div.post > div.episode-description > p:nth-child(1)"
					page.doc.css(css_path_to_desc).children.each do |child|
						desc += child if child.kind_of? Nokogiri::XML::Text
					end

					episode = Rebuild::DB::Episode.create!(
						no: page.url.request_uri.delete("/"), 
						title: page.doc.at('title').inner_html,
						description: desc
						)

					page.doc.css('.episode-description > ul > li > a').each do |element|
						
						p "url: #{element.inner_html}, title:#{element.attributes["href"].value}"

						Rebuild::DB::ShowNote.create!(
							episode_id: episode.id,
							note: element.inner_html,
							url: element.attributes["href"].value,
							)
					end
				end
			end

		rescue => ex
			p "----------------"
			pp ex
			p "----------------"
		end


	end

end