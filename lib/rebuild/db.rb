require "sqlite3"
require "active_record"

module Rebuild

	# @db = SQLite3::Database.new("anemone.db")

	module DB
		
		ActiveRecord::Base.establish_connection(
			adapter: "sqlite3",
			database: "/Users/yuto-ogi/Work/ruby/rebuild/lib/anemone.db")

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
			has_many :shownotes, :foreign_key => "episode_id", :class_name => "ShowNote"
		end

		class ShowNote < ActiveRecord::Base
		end

	end
end
