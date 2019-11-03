import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unreel/models/movie.dart';
import 'package:unreel/models/movie_data.dart';
import 'package:unreel/models/settings.dart';
import 'package:unreel/services/movies.dart';
import 'package:unreel/widgets/genres_bar.dart';
import 'package:unreel/widgets/movie_description.dart';
import 'package:unreel/widgets/title_display.dart';

int resultsPerPage = 20;

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
              '$imageURL$backdropSize${Movie.fromJson(movieData.discoveryListData['results'][movieData.movieIndex + 1]).backdropPath}'),
          context);
    }
    movieData.changeNextMovie(await Movies()
        .getMovieDetails(movieData.movieList[movieData.movieIndex + 1]));
  }

  void init() async {
    var settings = Provider.of<Settings>(context);
    var movieData = Provider.of<MovieData>(context);
    if (movieData.discoveryListData == null) {
      movieData.discoveryListData = 0;
      movieData.discoveryListData = await Movies().getMovies(
          settings.genre['id'],
          settings.minRating,
          settings.minVotes,
          DateTime.utc(settings.yearSpan.start.toInt(), 1, 1),
          DateTime.utc(settings.yearSpan.end.toInt(), 12, 31),
          movieData.page);
      movieData.movieList.clear();
      if (movieData.discoveryListData == null) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFF1D2733),
            content: Text(
              'No movies found! :(',
              style: TextStyle(color: Colors.white),
            ),
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
    if (movieData.movieIndex != resultsPerPage - 2) {
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
            backgroundColor: Color(0xFF1D2733),
            content: Text(
              'No movies found! :(',
              style: TextStyle(color: Colors.white),
            ),
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
          TitleDisplay(
            movie: movieData.currentMovie,
            isSaved: false,
          ),
          GenresBar(movie: movieData.currentMovie),
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
