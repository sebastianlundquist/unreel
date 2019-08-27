import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _voteAverageValue = 5.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: Text('Min. Rating')),
              Expanded(
                flex: 3,
                child: Slider(
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
        ],
      ),
    );
  }
}
