import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/settings.dart';
import 'package:movie_app/services/movies.dart';
import 'package:movie_app/widgets/genres_bar.dart';
import 'package:movie_app/widgets/movie_description.dart';
import 'package:movie_app/models/shawshank.dart';
import 'package:movie_app/widgets/title_display.dart';
import 'package:provider/provider.dart';

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

void resetMovies() {
  movieIndex = 0;
  page = 1;
  discoveryListData = null;
}

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  void preloadNextMovie() async {
    precacheImage(
        NetworkImage(
            '$imageURL$backdropSize${Movie.fromJson(discoveryListData['results'][movieIndex]).backdropPath}'),
        context);
    nextMovie = await Movies().getMovieDetails(movieList[movieIndex]);
  }

  void init() async {
    if (discoveryListData == null) {
      discoveryListData = 0;
      discoveryListData = await Movies().getMovies(
          Provider.of<Settings>(context).genre,
          Provider.of<Settings>(context).minRating,
          Provider.of<Settings>(context).minVotes,
          DateTime.utc(
              Provider.of<Settings>(context).yearSpan.start.toInt(), 1, 1),
          DateTime.utc(
              Provider.of<Settings>(context).yearSpan.end.toInt(), 12, 31),
          page);
      movieList.clear();
      for (var movie in discoveryListData['results'])
        movieList.add(movie['id']);
      preloadNextMovie();
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Column(
      children: <Widget>[
        TitleDisplay(backdropImage: backdropImage, movieObject: actualMovie),
        GenresBar(movieObject: actualMovie),
        MovieDescription(movieObject: actualMovie),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: FloatingActionButton(
            onPressed: () async {
              if (movieIndex != resultsPerPage - 1) {
                setState(() {
                  actualMovie = nextMovie;
                  backdropImage = NetworkImage(
                      '$imageURL$backdropSize${actualMovie.backdropPath}');
                });
                movieIndex++;
              } else {
                setState(() {
                  actualMovie = nextMovie;
                  backdropImage = NetworkImage(
                      '$imageURL$backdropSize${actualMovie.backdropPath}');
                });
                movieIndex = 0;
                page++;
                discoveryListData = await Movies().getMovies(
                    Provider.of<Settings>(context).genre['id'],
                    Provider.of<Settings>(context).minRating,
                    Provider.of<Settings>(context).minVotes,
                    DateTime.utc(
                        Provider.of<Settings>(context).yearSpan.start.toInt(),
                        1,
                        1),
                    DateTime.utc(
                        Provider.of<Settings>(context).yearSpan.end.toInt(),
                        12,
                        31),
                    page);
                movieList.clear();
                for (var movie in discoveryListData['results'])
                  movieList.add(movie['id']);
              }
              preloadNextMovie();
            },
            child: Icon(Icons.refresh),
          ),
        ),
      ],
    );
  }
}
