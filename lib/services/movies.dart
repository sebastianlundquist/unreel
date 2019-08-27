import 'networking.dart';

const apiKey = 'bc0a0c6901ec87ac2bd09dc2264bb1af';
const url = 'https://api.themoviedb.org/3';

class Movies {
  Future<dynamic> getMovies(DateTime minReleaseDate, DateTime maxReleaseDate,
      int minVoteCount, double minVoteAverage, int page) async {
    String completeURL =
        '$url/discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=$page&primary_release_date.gte=${minReleaseDate.toIso8601String()}&primary_release_date.lte=${maxReleaseDate.toIso8601String()}';
    NetworkHelper networkHelper = NetworkHelper(completeURL);
    print(completeURL);
    var movieData = await networkHelper.getData();
    return movieData;
  }

  Future<dynamic> getMovieDetails(int id) async {
    String completeURL = '$url/movie/$id?api_key=$apiKey&language=en-US';
    NetworkHelper networkHelper = NetworkHelper(completeURL);
    print(completeURL);
    var movieData = await networkHelper.getData();
    return movieData;
  }
}
