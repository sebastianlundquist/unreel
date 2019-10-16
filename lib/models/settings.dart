import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Settings extends ChangeNotifier {
  Settings();
  int genre = 28;
  String genreName = 'Action';
  double minRating = 4.0;
  int minVotes = 0;
  RangeValues yearSpan = RangeValues(
      DateTime.now().year.toDouble() - 100, DateTime.now().year.toDouble());

  static const Map<int, String> genres = {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Science Fiction',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western'
  };

  void changeGenre(String newGenre) {
    genre = genres.keys
        .firstWhere((k) => genres[k] == newGenre, orElse: () => null);
    genreName = newGenre;
    notifyListeners();
  }

  void changeMinRating(double newMinRating) {
    minRating = newMinRating;
    notifyListeners();
  }

  void changeMinVotes(int newMinVotes) {
    minVotes = newMinVotes;
    notifyListeners();
  }

  void changeYearSpan(RangeValues values) {
    yearSpan = values;
    notifyListeners();
  }
}
