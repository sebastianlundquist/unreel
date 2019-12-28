import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unreel/models/movie_data.dart';
import 'package:unreel/models/settings.dart';
import 'package:unreel/services/movies.dart';
import 'package:unreel/services/utils.dart';
import 'package:unreel/widgets/genres_bar.dart';
import 'package:unreel/widgets/movie_description.dart';
import 'package:unreel/widgets/title_display.dart';

int resultsPerPage = 20;
bool isSnackBarActive = false;

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen>
    with AfterLayoutMixin<RecommendationScreen> {
  Future<bool> init() async {
    var settings = Provider.of<Settings>(context);
    var movieData = Provider.of<MovieData>(context);
    if (movieData.discoveryListData == null && !movieData.endOfListIsReached) {
      var movieList = await Movies().getMovies(
          settings.genre['id'],
          settings.minRating,
          settings.minVotes,
          DateTime.utc(settings.yearSpan.start.toInt(), 1, 1),
          DateTime.utc(settings.yearSpan.end.toInt(), 12, 31),
          movieData.page);
      if (movieList == null) {
        movieData.initialLoadSuccessful = false;
        Utils.showSnackBar(
            'Couldn\'t fetch movies. Check your connection.', context);
        return false;
      } else {
        movieData.changeDiscoveryListData(movieList);
        movieData.movieList.clear();
        for (var movie in movieData.discoveryListData['results'])
          movieData.movieList.add(movie['id']);
        movieData.preloadNextMovie(context);
        movieData.initialLoadSuccessful = true;
      }
    }
    return true;
  }

  void goToNextMovie() async {
    var settings = Provider.of<Settings>(context);
    var movieData = Provider.of<MovieData>(context);
    if (!movieData.endOfListIsReached) {
      try {
        movieData.changeCurrentMovie(movieData.nextMovie);
        movieData.changeBackdropImage(NetworkImage(
            '$imageURL$backdropSize${movieData.currentMovie.backdropPath}'));
        if (movieData.movieIndex != resultsPerPage - 2) {
          movieData.changeMovieIndex(movieData.movieIndex + 1);
        } else {
          movieData.changeMovieIndex(0);
          movieData.changePage(movieData.page + 1);
          var movieList = await Movies().getMovies(
              settings.genre['id'],
              settings.minRating,
              settings.minVotes,
              DateTime.utc(settings.yearSpan.start.toInt(), 1, 1),
              DateTime.utc(settings.yearSpan.end.toInt(), 12, 31),
              movieData.page);
          if (movieList == null) return;
          movieData.changeDiscoveryListData(movieList);
          movieData.movieList.clear();
          if (movieData.discoveryListData == null) {
            Utils.showSnackBar('No movies found! :(', context);
          } else {
            for (var movie in movieData.discoveryListData['results'])
              movieData.movieList.add(movie['id']);
          }
        }
        if (movieData.endOfListIsReached) {
          Utils.showSnackBar(
              'No more movies match your filters. Change them to discover more movies!',
              context);
        }
        movieData.nextMovieExists = await movieData.preloadNextMovie(context);
        if (!movieData.nextMovieExists) {
          movieData.changeMovieIndex(movieData.movieIndex - 1);
          Utils.showSnackBar(
              'Couldn\'t fetch new movies. Check your connection.', context);
        }
      } catch (e) {
        Utils.showSnackBar(
            'Couldn\'t fetch new movies. Check your connection.', context);
      }
    } else {
      Utils.showSnackBar(
          'No more movies match your filters. Change them to discover more movies!',
          context);
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    init();
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () async {
                  if (!movieData.initialLoadSuccessful) {
                    await init();
                  }
                  if (movieData.nextMovie != null &&
                      movieData.currentMovie != movieData.nextMovie) {
                    goToNextMovie();
                  } else {
                    await movieData.preloadNextMovie(context);
                    goToNextMovie();
                  }
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
