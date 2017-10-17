describe Movie do
  describe 'all_ratings method' do
    it 'getting all ratings' do
      @all_ratings = Movie.all_ratings
      expect @all_ratings.count > 0
    end
  end
  describe 'searching Tmdb by keyword' do
    context 'with valid key' do
      it 'should call Tmdb with title keywords which yeilds results' do
        @matching_movies = Movie.find_in_tmdb('Godfather')
        expect @matching_movies.count > 0
      end
    end
    context 'with invalid key' do
      it 'should raise InvalidKeyError if key is missing or invalid' do
        allow(Tmdb::Movie).to receive(:find).and_raise(Tmdb::InvalidApiKeyError)
        expect {Movie.find_in_tmdb('Inception') }.to raise_error(Movie::InvalidKeyError)
      end
    end
  end
  describe 'create_from_tmdb' do
    it 'insert the movie whose id is sent as parameter' do
      #expect(Movie).to receive(:create_from_tmdb).with('244')
      Movie.create_from_tmdb('244')
      record = Movie.where("title = 'King Kong'")
      expect record.count > 0
    end
  end
end
 
