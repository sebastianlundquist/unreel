import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

const List<Map<String, dynamic>> genres = [
  {'id': -1, 'name': 'Any'},
  {'id': 28, 'name': 'Action'},
  {'id': 12, 'name': 'Adventure'},
  {'id': 16, 'name': 'Animation'},
  {'id': 35, 'name': 'Comedy'},
  {'id': 80, 'name': 'Crime'},
  {'id': 99, 'name': 'Documentary'},
  {'id': 18, 'name': 'Drama'},
  {'id': 10751, 'name': 'Family'},
  {'id': 14, 'name': 'Fantasy'},
  {'id': 36, 'name': 'History'},
  {'id': 27, 'name': 'Horror'},
  {'id': 10402, 'name': 'Music'},
  {'id': 9648, 'name': 'Mystery'},
  {'id': 10749, 'name': 'Romance'},
  {'id': 878, 'name': 'Science Fiction'},
  {'id': 10770, 'name': 'TV Movie'},
  {'id': 53, 'name': 'Thriller'},
  {'id': 10752, 'name': 'War'},
  {'id': 37, 'name': 'Western'}
];

class Settings extends ChangeNotifier {
  Settings();
  double minRating = 4.0;
  int minVotes = 0;
  RangeValues yearSpan = RangeValues(
      DateTime.now().year.toDouble() - 100, DateTime.now().year.toDouble());

  Map<String, dynamic> genre = genres[0];

  void changeGenre(String newGenre) {
    for (var g in genres) {
      if (g['name'] == newGenre) {
        genre = g;
        break;
      }
    }
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
