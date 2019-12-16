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
bool isSnackBarActive = false;
bool endOfListIsReached = false;

class RecommendationScreen extends StatefulWidget {
  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  Future<bool> preloadNextMovie() async {
    var movieData = Provider.of<MovieData>(context);
    var movieListLength = movieData.movieList.length;
    var nextMovieIndex = movieData.movieIndex + 1;
    if (nextMovieIndex < movieListLength) {
      endOfListIsReached = false;
      var nextMovie =
          await Movies().getMovieDetails(movieData.movieList[nextMovieIndex]);
      if (nextMovie != null) {
        movieData.changeNextMovie(nextMovie);
        if (movieData.discoveryListData != null) {
          precacheImage(
              NetworkImage(
                  '$imageURL$backdropSize${Movie.fromJson(movieData.discoveryListData['results'][movieData.movieIndex + 1]).backdropPath}'),
              context, onError: (e, stackTrace) {
            print('Could not precache image. Reason:\n' + e.toString());
            return false;
          });
        }
        return true;
      } else {
        return false;
      }
    } else {
      endOfListIsReached = true;
      return false;
    }
  }

  void init() async {
    var settings = Provider.of<Settings>(context);
    var movieData = Provider.of<MovieData>(context);
    if (movieData.discoveryListData == null) {
      var movieList = await Movies().getMovies(
          settings.genre['id'],
          settings.minRating,
          settings.minVotes,
          DateTime.utc(settings.yearSpan.start.toInt(), 1, 1),
          DateTime.utc(settings.yearSpan.end.toInt(), 12, 31),
          movieData.page);
      if (movieList == null) return;
      movieData.changeDiscoveryListData(movieList);
      if (movieData.discoveryListData == null) {
        if (!isSnackBarActive) {
          isSnackBarActive = true;
          Scaffold.of(context)
              .showSnackBar(
                SnackBar(
                  backgroundColor: Color(0xFF1D2733),
                  content: Text(
                    'Couldn\'t fetch new movies. Check your connection.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
              .closed
              .then((SnackBarClosedReason reason) {
            isSnackBarActive = false;
          });
        }
        return;
      }
      movieData.movieList.clear();
      if (movieData.discoveryListData == null && !isSnackBarActive) {
        isSnackBarActive = true;
        Scaffold.of(context)
            .showSnackBar(
              SnackBar(
                backgroundColor: Color(0xFF1D2733),
                content: Text(
                  'No movies found! :(',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
            .closed
            .then((SnackBarClosedReason reason) {
          isSnackBarActive = false;
        });
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
    if (!endOfListIsReached) {
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
          if (movieData.discoveryListData == null && !isSnackBarActive) {
            isSnackBarActive = true;
            Scaffold.of(context)
                .showSnackBar(
                  SnackBar(
                    backgroundColor: Color(0xFF1D2733),
                    content: Text(
                      'No movies found! :(',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
                .closed
                .then((SnackBarClosedReason reason) {
              isSnackBarActive = false;
            });
          } else {
            for (var movie in movieData.discoveryListData['results'])
              movieData.movieList.add(movie['id']);
          }
        }
        preloadNextMovie();
      } catch (e) {
        if (!isSnackBarActive) {
          isSnackBarActive = true;
          Scaffold.of(context)
              .showSnackBar(
                SnackBar(
                  backgroundColor: Color(0xFF1D2733),
                  content: Text(
                    'Couldn\'t fetch new movies. Check your connection.',
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
    } else {
      if (!isSnackBarActive) {
        isSnackBarActive = true;
        Scaffold.of(context)
            .showSnackBar(
              SnackBar(
                backgroundColor: Color(0xFF1D2733),
                content: Text(
                  'There are no new movies! :(',
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
                onPressed: () async {
                  print("current: " + movieData.currentMovie.title);
                  print("next: " + movieData.nextMovie.title);
                  if (movieData.nextMovie != null &&
                      movieData.currentMovie != movieData.nextMovie) {
                    goToNextMovie();
                  } else {
                    bool nextMovieIsLoaded = await preloadNextMovie();
                    if (nextMovieIsLoaded) {
                      goToNextMovie();
                    } else {
                      if (!isSnackBarActive) {
                        isSnackBarActive = true;
                        Scaffold.of(context)
                            .showSnackBar(
                              SnackBar(
                                backgroundColor: Color(0xFF1D2733),
                                content: Text(
                                  'Couldn\'t fetch movie. Please check your connection.',
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
