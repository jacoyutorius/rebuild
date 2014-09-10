require "sqlite3"
require "active_record"

module Rebuild

	module DB

		dbpath = "/Users/yuto-ogi/Work/ruby/rebuild/lib/anemone.db"
		
		ActiveRecord::Base.establish_connection(
			adapter: "sqlite3",
			database: dbpath)


		def self.init
			DBMigration.new.up
		end

		def self.create
			
		end

		def self.delete
			DBMigration.new.down
		end

		class DBMigration < ActiveRecord::Migration
			def self.up
				create_table :episodes do |t|
					t.integer :no
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

		class Storage < ActiveRecord::Base
			self.table_name = "anemone_storage"
		end

		class Episode < ActiveRecord::Base
			# has_many :shownotes, :foreign_key => "episode_id", :class_name => "ShowNote"
			has_many :shownotes

			def self.exist? episode_no
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
