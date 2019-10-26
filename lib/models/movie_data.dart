import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/models/shawshank.dart';
import 'movie.dart';

class MovieData extends ChangeNotifier {
  MovieData();
  Movie currentMovie = Movie.fromJson(shawshank);
  Movie nextMovie = Movie.fromJson(shawshank);
  ImageProvider backdropImage = AssetImage('images/shawshank_backdrop.jpg');
  dynamic discoveryListData;
  int movieIndex = 0;
  int page = 1;
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
}
