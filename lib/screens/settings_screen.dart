import 'package:flutter/material.dart';
import 'package:movie_app/models/settings.dart';
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
        child: Column(
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
                      value: Provider.of<Settings>(context).genre['name'],
                      iconEnabledColor: Colors.amber,
                      onChanged: (newValue) {
                        Provider.of<Settings>(context).changeGenre(newValue);
                        resetMovies();
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          Provider.of<Settings>(context).minRating.toString(),
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
                            Provider.of<Settings>(context)
                                .changeMinRating(newRating);
                          },
                          onChangeEnd: (newRating) {
                            resetMovies();
                          },
                          value: Provider.of<Settings>(context).minRating,
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          Provider.of<Settings>(context).minVotes.toString(),
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
                            Provider.of<Settings>(context)
                                .changeMinVotes(newVotes.toInt());
                          },
                          onChangeEnd: (newVotes) {
                            resetMovies();
                          },
                          value: Provider.of<Settings>(context)
                              .minVotes
                              .toDouble(),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          Provider.of<Settings>(context)
                              .yearSpan
                              .start
                              .toInt()
                              .toString(),
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
                        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 0.0, 0.0),
                        child: Text(
                          Provider.of<Settings>(context)
                              .yearSpan
                              .end
                              .toInt()
                              .toString(),
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
                            Provider.of<Settings>(context)
                                .changeYearSpan(values);
                          },
                          onChangeEnd: (values) {
                            resetMovies();
                          },
                          values: Provider.of<Settings>(context).yearSpan,
                          divisions: 100,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
