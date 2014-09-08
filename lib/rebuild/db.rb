require "active_record"

module Rebuild
  module DB

    
	
    class Episode < ActiveRecord::Base
      # has_many :snownotes, 


    def self.list
      (1..54).each do |i|
        puts i
      end
    end

    end

    class ShowNote < ActiveRecord::Base
      def self.find_by_episode episode_no
       ar = []
       %w(github.com/amatsuda Asakusa.rb Seattle.rb クックパッドにおける最近のActiveRecord運用事情).each do |v|
          ar << v
        end

        ar
      end
    end

  

  end	
end
