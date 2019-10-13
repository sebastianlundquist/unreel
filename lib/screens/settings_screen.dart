import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _voteAverageValue = 5.0;
  int _minimumVotes = 0;
  RangeValues _rangeValues = RangeValues(1940, DateTime.now().year.toDouble());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Min. Rating')),
                Expanded(
                  flex: 3,
                  child: Slider(
                    activeColor: Colors.amber,
                    min: 0.0,
                    max: 10.0,
                    onChanged: (newRating) {
                      setState(() => _voteAverageValue = newRating);
                    },
                    value: _voteAverageValue,
                    divisions: 10,
                    label: _voteAverageValue.toString(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Min. Votes')),
                Expanded(
                  flex: 3,
                  child: Slider(
                    activeColor: Colors.amber,
                    min: 0,
                    max: 10000,
                    onChanged: (newVotes) {
                      setState(() => _minimumVotes = newVotes.toInt());
                    },
                    value: _minimumVotes.toDouble(),
                    divisions: 10,
                    label: _minimumVotes.toString(),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(child: Text('Year')),
                Expanded(
                  flex: 3,
                  child: RangeSlider(
                    activeColor: Colors.amber,
                    min: DateTime.now().year.toDouble() - 100,
                    max: DateTime.now().year.toDouble(),
                    onChanged: (RangeValues values) {
                      setState(() => _rangeValues = values);
                    },
                    values: _rangeValues,
                    divisions: 100,
                    labels: RangeLabels(
                      _rangeValues.start.toInt().toString(),
                      _rangeValues.end.toInt().toString(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
