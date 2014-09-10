require "anemone"
require "sqlite3"

module Rebuild

	module Crawler
		def self.fetch
			puts "updated show list!"


			url = "http://rebuild.fm/"

			option = {
				storage: Anemone::Storage.SQLite3
			}


			Anemone.crawl(url, option) do |anemone|

				anemone.focus_crawl do |page|
					page.links.keep_if do |link|
						link.to_s.match(/http:\/\/rebuild.fm\/[0-9]+|[a]/)
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
						
						# p "url: #{element.inner_html}, title:#{element.attributes["href"].value}"

						Rebuild::DB::ShowNote.create!(
							episode_id: episode.id,
							note: element.inner_html,
							url: element.attributes["href"].value,
							)
					end
				end
			end

		end


	end

end