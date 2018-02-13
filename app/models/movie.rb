class Movie < ActiveRecord::Base
    def self.get_ratings_collection
        return ["G", "PG", "PG-13", "R"]
    end
    
end
