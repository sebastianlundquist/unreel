import 'package:flutter/material.dart';
import 'package:movie_app/models/movie.dart';
import 'package:movie_app/models/movie_data.dart';
import 'package:movie_app/models/settings.dart';
import 'package:movie_app/services/movies.dart';
import 'package:movie_app/widgets/genres_bar.dart';
import 'package:movie_app/widgets/movie_description.dart';
import 'package:movie_app/models/shawshank.dart';
import 'package:movie_app/widgets/title_display.dart';
import 'package:provider/provider.dart';

const imageURL = 'https://image.tmdb.org/t/p';
const backdropSize = '/w780';

int resultsPerPage = 20;

void resetMovies(MovieData movieData) {
  print("reset movies");
  movieData.movieIndex = 0;
  movieData.page = 1;
  movieData.discoveryListData = null;
  movieData.currentMovie = Movie.fromJson(shawshank);
  movieData.nextMovie = Movie.fromJson(shawshank);
}

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  void preloadNextMovie() async {
    var movieData = Provider.of<MovieData>(context);
    if (movieData.discoveryListData != null) {
      precacheImage(
          NetworkImage(
              '$imageURL$backdropSize${Movie.fromJson(movieData.discoveryListData['results'][movieData.movieIndex]).backdropPath}'),
          context);
    }
    movieData.changeNextMovie(await Movies()
        .getMovieDetails(movieData.movieList[movieData.movieIndex]));
  }

  void init() async {
    print("init");
    var settings = Provider.of<Settings>(context);
    var movieData = Provider.of<MovieData>(context);
    if (movieData.discoveryListData == null) {
      print("listData is null");
      movieData.discoveryListData = 0;
      movieData.discoveryListData = await Movies().getMovies(
          settings.genre['id'],
          settings.minRating,
          settings.minVotes,
          DateTime.utc(settings.yearSpan.start.toInt(), 1, 1),
          DateTime.utc(settings.yearSpan.end.toInt(), 12, 31),
          movieData.page);
      /*
      movieData.changeDiscoveryListData(0);
      movieData.changeDiscoveryListData(await Movies().getMovies(
          settings.genre['id'],
          settings.minRating,
          settings.minVotes,
          DateTime.utc(settings.yearSpan.start.toInt(), 1, 1),
          DateTime.utc(settings.yearSpan.end.toInt(), 12, 31),
          movieData.page));

       */
      movieData.movieList.clear();
      if (movieData.discoveryListData == null) {
        /*
        movieData.changeCurrentMovie(Movie.fromJson(shawshank));
        movieData
            .changeBackdropImage(AssetImage('images/shawshank_backdrop.jpg'));

         */
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('No movies found! :('),
          ),
        );
      } else {
        for (var movie in movieData.discoveryListData['results'])
          movieData.movieList.add(movie['id']);
        preloadNextMovie();
      }
    }
  }

  void goToNextMovie() async {
    var settings = Provider.of<Settings>(context);
    var movieData = Provider.of<MovieData>(context);
    movieData.changeCurrentMovie(movieData.nextMovie);
    movieData.changeBackdropImage(NetworkImage(
        '$imageURL$backdropSize${movieData.currentMovie.backdropPath}'));
    if (movieData.movieIndex != resultsPerPage - 1) {
      movieData.changeMovieIndex(movieData.movieIndex + 1);
    } else {
      movieData.changeMovieIndex(0);
      movieData.changePage(movieData.page + 1);
      movieData.changeDiscoveryListData(await Movies().getMovies(
          settings.genre['id'],
          settings.minRating,
          settings.minVotes,
          DateTime.utc(settings.yearSpan.start.toInt(), 1, 1),
          DateTime.utc(settings.yearSpan.end.toInt(), 12, 31),
          movieData.page));
      movieData.movieList.clear();
      if (movieData.discoveryListData == null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('No movies found! :('),
          ),
        );
      } else {
        for (var movie in movieData.discoveryListData['results'])
          movieData.movieList.add(movie['id']);
      }
    }
    preloadNextMovie();
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<MovieData>(context).discoveryListData == null) init();
    return Consumer<MovieData>(builder: (context, movieData, child) {
      return Column(
        children: <Widget>[
          TitleDisplay(),
          GenresBar(movieObject: movieData.currentMovie),
          MovieDescription(movieObject: movieData.currentMovie),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Consumer<Settings>(builder: (context, settings, child) {
              return FloatingActionButton(
                onPressed: () {
                  goToNextMovie();
                },
                child: Icon(Icons.refresh),
              );
            }),
          ),
        ],
      );
    });
  }
}
