require "sqlite3"
require "active_record"

module Rebuild
	module DB

		ActiveRecord::Base.establish_connection(
			adapter: "sqlite3",
			database: "./anemone.db")


		def self.init
			if File.exists? "./anemone.db"
				puts "Database already exist!" 
			else
				DBMigration.new.up
			end
		end

		def self.delete
			DBMigration.new.down
		end

		class DBMigration < ActiveRecord::Migration
			def self.up
				create_table :episodes do |t|
					t.string :no
					t.string :title
					t.string :description
				end

				create_table :show_notes do |t|
					t.integer :episode_id
					t.string :note 
					t.string :url
				end
			end

			def self.down
				drop_table :episodes
				drop_table :show_notes
			end
		end


		class Episode < ActiveRecord::Base
			has_many :shownotes, :foreign_key => "episode_id", :class_name => "ShowNote"

			def self.exists? episode_no
				raise "Episode #{episode_no} does not exist!" unless self.find_by_no(episode_no)
			end

		end

		class ShowNote < ActiveRecord::Base
			belongs_to :episode
			
			def self.search keyword
				self.where("note like '%#{keyword}%'")
			end

		end

	end
end
