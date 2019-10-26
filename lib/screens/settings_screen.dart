import 'package:flutter/material.dart';
import 'package:movie_app/models/settings.dart';
import 'package:movie_app/services/movies.dart';
import 'package:provider/provider.dart';

import 'recommendation_screen.dart';

List<String> genreNames;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  List<String> vowels = ['a', 'e', 'i', 'o', 'u', 'y'];
  String watchText = 'a';

  void newMovieSearch(Settings settings) async {
    resetMovies();
    discoveryListData = await Movies().getMovies(
        settings.genre['id'],
        settings.minRating,
        settings.minVotes,
        DateTime.utc(settings.yearSpan.start.toInt(), 1, 1),
        DateTime.utc(settings.yearSpan.end.toInt(), 12, 31),
        page);
    movieList.clear();
    if (discoveryListData == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('No movies found! :('),
        ),
      );
    } else {
      for (var movie in discoveryListData['results'])
        movieList.add(movie['id']);
    }
  }

  @override
  Widget build(BuildContext context) {
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
      }
    }
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
                            newMovieSearch(settings);
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
                                newMovieSearch(settings);
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
                                newMovieSearch(settings);
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
                                newMovieSearch(settings);
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
