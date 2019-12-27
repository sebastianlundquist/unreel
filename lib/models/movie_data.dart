import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:unreel/models/movie.dart';
import 'package:unreel/models/shawshank.dart';
import 'package:unreel/services/movies.dart';

const imageURL = 'https://image.tmdb.org/t/p';
const backdropSize = '/w780';

class MovieData extends ChangeNotifier {
  MovieData();
  Movie currentMovie = Movie.fromJson(shawshank);
  Movie nextMovie = Movie.fromJson(shawshank);
  ImageProvider backdropImage = AssetImage('images/shawshank_backdrop.jpg');
  dynamic discoveryListData;
  int movieIndex = -1;
  int page = 1;
  bool endOfListIsReached = false;
  bool nextMovieExists = false;
  var movieList = new List<int>();

  void changeCurrentMovie(Movie newCurrentMovie) {
    currentMovie = newCurrentMovie;
    notifyListeners();
  }

  void changeNextMovie(Movie newNextMovie) {
    nextMovie = newNextMovie;
    notifyListeners();
  }

  void changeBackdropImage(ImageProvider newBackdropImage) {
    backdropImage = newBackdropImage;
    notifyListeners();
  }

  void changeDiscoveryListData(dynamic newDiscoveryListData) {
    discoveryListData = newDiscoveryListData;
    notifyListeners();
  }

  void changeMovieIndex(int newMovieIndex) {
    movieIndex = newMovieIndex;
    notifyListeners();
  }

  void changePage(int newPage) {
    page = newPage;
    notifyListeners();
  }

  void changeMovieList(List<int> newMovieList) {
    movieList = newMovieList;
    notifyListeners();
  }

  Future<bool> preloadNextMovie(BuildContext context) async {
    nextMovieExists = false;
    var movieListLength = movieList.length;
    var nextMovieIndex = movieIndex + 1;
    if (nextMovieIndex < movieListLength) {
      endOfListIsReached = false;
      var nextMovie = await Movies().getMovieDetails(movieList[nextMovieIndex]);
      if (nextMovie != null) {
        changeNextMovie(nextMovie);
        if (discoveryListData != null &&
            discoveryListData['results'][movieIndex + 1]['backdrop_path'] !=
                null) {
          precacheImage(
              NetworkImage(
                  '$imageURL$backdropSize${Movie.fromJson(discoveryListData['results'][movieIndex + 1]).backdropPath}'),
              context, onError: (e, stackTrace) {
            print('Could not precache image. Reason:\n' + e.toString());
            return false;
          });
        }
        nextMovieExists = true;
        return true;
      } else {
        return false;
      }
    } else {
      endOfListIsReached = true;
      return false;
    }
  }
}
