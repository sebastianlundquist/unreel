import 'package:flutter/material.dart';
import 'package:unreel/models/movie.dart';
import 'package:unreel/models/movie_data.dart';
import 'package:unreel/models/settings.dart';
import 'package:unreel/models/shawshank.dart';
import 'package:unreel/services/movies.dart';
import 'package:provider/provider.dart';

List<String> genreNames;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> vowels = ['a', 'e', 'i', 'o', 'u', 'y'];
  String watchText = 'a';

  void newMovieSearch() async {
    var settings = Provider.of<Settings>(context);
    var movieData = Provider.of<MovieData>(context);
    movieData.changeMovieIndex(0);
    movieData.changePage(1);
    movieData.discoveryListData = null;
    movieData.changeCurrentMovie(Movie.fromJson(shawshank));
    movieData.changeNextMovie(Movie.fromJson(shawshank));
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
      if (movieData.discoveryListData['results'].length > 0) {
        movieData.changeCurrentMovie(await Movies()
            .getMovieDetails(movieData.movieList[movieData.movieIndex]));
        movieData.changeBackdropImage(NetworkImage(
            '$imageURL$backdropSize${movieData.currentMovie.backdropPath}'));
      }
      if (movieData.discoveryListData['results'].length > 1) {
        movieData.changeNextMovie(await Movies()
            .getMovieDetails(movieData.movieList[movieData.movieIndex + 1]));
        precacheImage(
            NetworkImage(
                '$imageURL$backdropSize${Movie.fromJson(movieData.discoveryListData['results'][movieData.movieIndex + 1]).backdropPath}'),
            context);
      }
    }
  }

  void changeWatchText() {
    genreNames = [];
    for (int i = 0; i < genres.length; i++) {
      genreNames.add(genres[i]['name']);
    }
    for (String vowel in vowels) {
      if (Provider.of<Settings>(context).genre['name'] == 'Any') {
        setState(() {
          watchText = '';
        });
        break;
      } else if (Provider.of<Settings>(context)
          .genre['name']
          .toLowerCase()
          .startsWith(vowel)) {
        setState(() {
          watchText = 'an';
        });
        break;
      } else {
        setState(() {
          watchText = 'a';
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    changeWatchText();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<Settings>(
          builder: (context, settings, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'I want to watch',
                  style: Theme.of(context)
                      .textTheme
                      .display1
                      .copyWith(fontStyle: FontStyle.italic),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          watchText,
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DropdownButton<String>(
                          value: settings.genre['name'],
                          iconEnabledColor: Colors.amber,
                          onChanged: (newValue) async {
                            settings.changeGenre(newValue);
                            newMovieSearch();
                          },
                          items: genreNames
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'movie',
                          style: Theme.of(context)
                              .textTheme
                              .body1
                              .copyWith(fontStyle: FontStyle.italic),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            'with a minimum',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              settings.minRating.toString(),
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ),
                          Text(
                            'rating',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Slider(
                              activeColor: Colors.amber,
                              min: 0.0,
                              max: 10.0,
                              onChanged: (newRating) {
                                settings.changeMinRating(newRating);
                              },
                              onChangeEnd: (newRating) {
                                newMovieSearch();
                              },
                              value: settings.minRating,
                              divisions: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            'and',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              settings.minVotes.toString(),
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ),
                          Text(
                            'votes',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontStyle: FontStyle.italic),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Slider(
                              activeColor: Colors.amber,
                              min: 0,
                              max: 10000,
                              onChanged: (newVotes) {
                                settings.changeMinVotes(newVotes.toInt());
                              },
                              onChangeEnd: (newVotes) {
                                newMovieSearch();
                              },
                              value: settings.minVotes.toDouble(),
                              divisions: 10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: <Widget>[
                          Text(
                            'between',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              settings.yearSpan.start.toInt().toString(),
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ),
                          Text(
                            'and',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                            child: Text(
                              settings.yearSpan.end.toInt().toString(),
                              style: Theme.of(context).textTheme.display1,
                            ),
                          ),
                          Text(
                            '.',
                            style: Theme.of(context)
                                .textTheme
                                .body1
                                .copyWith(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: RangeSlider(
                              activeColor: Colors.amber,
                              min: DateTime.now().year.toDouble() - 100,
                              max: DateTime.now().year.toDouble(),
                              onChanged: (RangeValues values) {
                                settings.changeYearSpan(values);
                              },
                              onChangeEnd: (values) {
                                newMovieSearch();
                              },
                              values: settings.yearSpan,
                              divisions: 100,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
