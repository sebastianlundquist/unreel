import 'package:flutter/material.dart';
import 'package:movie_app/models/genres.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _voteAverageValue = 5.0;
  int _minimumVotes = 0;
  RangeValues _rangeValues = RangeValues(1940, DateTime.now().year.toDouble());
  String _genreValue = 'Action';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'I want to watch a',
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
                  DropdownButton<String>(
                      value: _genreValue,
                      iconEnabledColor: Colors.amber,
                      onChanged: (newValue) {
                        setState(() => _genreValue = newValue);
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
                          _voteAverageValue.toString(),
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
                            setState(() => _voteAverageValue = newRating);
                          },
                          value: _voteAverageValue,
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
                        'and',
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          _minimumVotes.toString(),
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
                            setState(() => _minimumVotes = newVotes.toInt());
                          },
                          value: _minimumVotes.toDouble(),
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
                    children: <Widget>[
                      Text(
                        'released between the years of',
                        style: Theme.of(context)
                            .textTheme
                            .body1
                            .copyWith(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          _rangeValues.start.toInt().toString(),
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
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          _rangeValues.end.toInt().toString(),
                          style: Theme.of(context).textTheme.display1,
                        ),
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
                            setState(() => _rangeValues = values);
                          },
                          values: _rangeValues,
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
