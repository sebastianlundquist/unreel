import 'package:flutter/material.dart';
import 'package:movie_app/screens/recommendation_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: RecommendationScreen(),
    );
  }
}
