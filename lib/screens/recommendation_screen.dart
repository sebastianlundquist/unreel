import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/services/movies.dart';
import 'package:movie_app/models/movie_light.dart';
import 'package:movie_app/widgets/genres_bar.dart';
import 'package:movie_app/widgets/movie_description.dart';
import 'package:movie_app/models/shawshank.dart';
import 'package:movie_app/widgets/title_display.dart';

const imageURL = 'https://image.tmdb.org/t/p';
const backdropSize = '/w780';

Movie actualMovie = Movie.fromJson(shawshank);
Movie nextMovie = Movie.fromJson(shawshank);
ImageProvider backdropImage = AssetImage('images/shawshank_backdrop.jpg');
dynamic discoveryListData;
int movieIndex = 0;
int page = 1;
int resultsPerPage = 20;
var movieList = new List<int>();

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  DateTime minReleaseDate = DateTime(2000, 1, 1);
  DateTime maxReleaseDate = DateTime(2010, 12, 31);
  int minVoteCount = 100;
  double minVoteAverage = 7.0;

  void preloadNextMovie() async {
    precacheImage(
        NetworkImage(
            '$imageURL$backdropSize${MovieLight.fromJson(discoveryListData['results'][movieIndex]).backdropPath}'),
        context);
    nextMovie = await Movies().getMovieDetails(movieList[movieIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TitleDisplay(backdropImage: backdropImage, movieObject: actualMovie),
        GenresBar(movieObject: actualMovie),
        MovieDescription(movieObject: actualMovie),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () async {
              if (movieIndex == 0 && page == 1) {
                discoveryListData = await Movies().getMovies(minReleaseDate,
                    maxReleaseDate, minVoteCount, minVoteAverage, page);
                movieList.clear();
                for (var movie in discoveryListData['results'])
                  movieList.add(movie['id']);
                actualMovie =
                    await Movies().getMovieDetails(movieList[movieIndex]);
                setState(() {
                  backdropImage = NetworkImage(
                      '$imageURL$backdropSize${actualMovie.backdropPath}');
                });
                movieIndex++;
                preloadNextMovie();
              } else if (movieIndex == resultsPerPage - 1) {
                setState(() {
                  actualMovie = nextMovie;
                  backdropImage = NetworkImage(
                      '$imageURL$backdropSize${actualMovie.backdropPath}');
                });
                movieIndex = 0;
                page++;
                discoveryListData = await Movies().getMovies(minReleaseDate,
                    maxReleaseDate, minVoteCount, minVoteAverage, page);
                movieList.clear();
                for (var movie in discoveryListData['results'])
                  movieList.add(movie['id']);
                preloadNextMovie();
              } else {
                setState(() {
                  actualMovie = nextMovie;
                  backdropImage = NetworkImage(
                      '$imageURL$backdropSize${actualMovie.backdropPath}');
                });
                movieIndex++;
                preloadNextMovie();
              }
            },
            child: Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}
