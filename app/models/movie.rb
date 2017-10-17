class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end
  
 class Movie::InvalidKeyError < StandardError ; end
  
  def self.find_in_tmdb(string)

    begin
      @final_table = []
      Tmdb::Api.key("f4702b08c0ac6ea5b51425788bb26562")
      matching_movies = Tmdb::Movie.find(string)
      #print matching_movies
      #print Tmdb::Movie.releases("440021")
      matching_movies.each do |mov_name|
        final_hash = {}
        #print mov_name.title
        #print mov_name.release_date
        ratings_var = Tmdb::Movie.releases(mov_name.id)
        #print ratings_var
        ratings_var["countries"].each do |rate|
          if rate["iso_3166_1"] = "US"
            rat = rate["certification"]
            if rat == ""
              rat = "NR"
            end
            final_hash = {:tmdb_id => mov_name.id, :title => mov_name.title, :release_date => mov_name.release_date,:rating => rat}
            break
          end
        end
        @final_table.push(final_hash)
         
      end
      
    rescue Tmdb::InvalidApiKeyError
        raise Movie::InvalidKeyError, 'Invalid API key'
    end
    return @final_table
  end
  def self.create_from_tmdb(tmdb_id)
    details = Tmdb::Movie.detail(tmdb_id)
    ratings = Tmdb::Movie.releases(tmdb_id)["countries"]
    movie_hash = Hash.new
    movie_hash = {:title => details["title"], :release_date => details["release_date"], :description => details["overview"]}
    ratings.each do|country_rating|
      if country_rating["iso_3166_1"] == "US"
        movie_hash[:rating] = country_rating["certification"]
        break
      end
    end
    Movie.create(movie_hash)
  end
  
end
