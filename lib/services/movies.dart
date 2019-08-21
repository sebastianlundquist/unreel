import 'networking.dart';

const apiKey = 'bc0a0c6901ec87ac2bd09dc2264bb1af';
const url = 'https://api.themoviedb.org/3';

class Movies {
  Future<dynamic> getMovies(int minReleaseDate, int maxReleaseDate,
      int minVoteCount, double minVoteAverage, int page) async {
    String completeURL =
        '$url/discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&include_adult=true&include_video=false&page=$page&primary_release_date.gte=$minReleaseDate&primary_release_date.lte=$maxReleaseDate';
    NetworkHelper networkHelper = NetworkHelper(completeURL);
    print(completeURL);
    var movieData = await networkHelper.getData();
    return movieData;
  }
}
