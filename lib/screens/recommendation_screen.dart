import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:unreel/models/movie_data.dart';
import 'package:unreel/models/settings.dart';
import 'package:unreel/services/movies.dart';
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
  void showSnackBar(String text) {
    if (!isSnackBarActive) {
      isSnackBarActive = true;
      Scaffold.of(context)
          .showSnackBar(
            SnackBar(
              backgroundColor: Color(0xFF1D2733),
              content: Text(
                text,
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
          .closed
          .then((SnackBarClosedReason reason) {
        isSnackBarActive = false;
      });
    }
  }

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
        showSnackBar('Couldn\'t fetch movies. Check your connection.');
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
            showSnackBar('No movies found! :(');
          } else {
            for (var movie in movieData.discoveryListData['results'])
              movieData.movieList.add(movie['id']);
          }
        }
        if (movieData.endOfListIsReached) {
          showSnackBar(
              'No more movies match your filters. Change them to discover more movies!');
        }
        movieData.nextMovieExists = await movieData.preloadNextMovie(context);
        if (!movieData.nextMovieExists) {
          movieData.changeMovieIndex(movieData.movieIndex - 1);
          showSnackBar('Couldn\'t fetch new movies. Check your connection.');
        }
      } catch (e) {
        showSnackBar('Couldn\'t fetch new movies. Check your connection.');
      }
    } else {
      showSnackBar(
          'No more movies match your filters. Change them to discover more movies!');
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    init();
  }

  @override
  Widget build(BuildContext context) {
    //if (Provider.of<MovieData>(context).discoveryListData == null) init();
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
